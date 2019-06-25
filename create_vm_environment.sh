#!/bin/bash

# Boot disk - change default disk size from 10GB.

sudo apt-get update
HOME=/home/dpalmer
INSTALL_DIR=/home/dpalmer/R/

# Install a bunch of packages to get R up and running on the cluster.
PKGS="bzip2 build-essential zlib1g-dev libbz2-dev liblzma-dev libcurl4-openssl-dev libpcre3-dev gfortran openjdk-8-jdk"
for p in $PKGS; do
    sudo apt-get install -y $p
done

# Install R 3.6.
wget https://cran.r-project.org/src/base/R-3/R-3.6.0.tar.gz
tar -xvzf R-3.6.0.tar.gz
rm R-3.6.0.tar.gz

cd R-3.6.0
./configure --with-readline=no --with-x=no --prefix=$INSTALL_DIR
make
make install

# Add R to the path.
export PATH=$INSTALL_DIR/bin:$PATH

# Install a bunch of packages:
Rscript -e 'install.packages(c("data.table",
	"plotly", "crosstalk", "dplyr", "DT", "kableExtra",
	"formattable", "htmltools"),
	repos="http://cran.rstudio.com")'

# Install git.
sudo apt-get install git
cd $HOME
# clone PHESANT library
git clone https://github.com/astheeggeggs/PHESANT.git

# Ensure that all of the files that are required have been copied over.

# Move the required reengineering_phenofile.r over.
gsutil cp gs://ukbb_association/reengineering_phenofile_neale_lab.r $HOME

# Move the raw phenotype file.
gsutil cp gs://ukbb_3106/ukb11214.csv $HOME

# Run the reegineering_phenofile.r on the raw phenotype data.
Rscript reengineering_phenofile_neale_lab.r # Note: may have to change hard-coding the start of this script.
# This will write a .tsv file that we then execute a PHESANT script on.

# Next, we wish to restrict to the subset of samples from our QC analysis.
gsutil cp gs://ukb31063-mega-gwas/qc/ukb31063.keep_samples.txt $HOME

Rscript restrict_to_QC_samples.r

cd PHESANT/WAS
# Execute the PHESANT script on the parsed phenotype file.
NUMPARTS=4

for i in `seq 1 $NUMPARTS`;
do
	Rscript phenomeScan.r \
		--phenofile="../../neale_lab_parsed_and_restricted_to_QCed_samples.tsv" \
		--variablelistfile="../variable-info/outcome_info_final_round2.tsv" \
		--datacodingfile="../variable-info/data-coding-ordinal-info.txt" \
		--userId="userId" \
		--resDir="../../" \
		--out="ukb11214_final_january_reference_QC_more_phenos_and_corrected" \
		--partIdx="$i" \
		--numParts="${NUMPARTS}"
done

for i in `seq 1 $NUMPARTS`;
do
Rscript phenomeScan.r \
	--phenofile="../../neale_lab_parsed_and_restricted_to_QCed_samples_males.tsv" \
	--variablelistfile="../variable-info/outcome_info_final_round2.tsv" \
	--datacodingfile="../variable-info/data-coding-ordinal-info.txt" \
	--userId="userId" \
	--resDir="../../" \
	--out="ukb11214_final_january_QC_males_more_phenos_and_corrected" \
	--partIdx="$i" \
	--numParts="${NUMPARTS}"
done

for i in `seq 1 $NUMPARTS`;
do
	Rscript phenomeScan.r \
	--phenofile="../../neale_lab_parsed_and_restricted_to_QCed_samples_females.tsv" \
	--variablelistfile="../variable-info/outcome_info_final_round2.tsv" \
	--datacodingfile="../variable-info/data-coding-ordinal-info.txt" \
	--userId="userId" \
	--resDir="../../" \
	--out="ukb11214_final_january_QC_females_more_phenos_and_corrected" \
	--partIdx="$i" \
	--numParts="${NUMPARTS}"
done

# Did it work?
