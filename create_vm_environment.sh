#!/bin/bash

# Boot disk - change default disk size from 10GB.

sudo apt-get update
HOME=/home/dpalmer
INSTALL_DIR=/home/dpalmer/R/

# Install a bunch of packages to get R up and running on the cluster.
PKGS="bzip2 build-essential zlib1g-dev libbz2-dev liblzma-dev libcurl4-openssl-dev libpcre3-dev gfortran openjdk-8-jdk libxml2-dev libssl-dev pandoc libcairo2-dev xorg libpango-1.0-0 xorg openbox gfortran"
for p in $PKGS; do
    sudo apt-get install -y $p
done

# Install R 3.6.
wget https://cran.r-project.org/src/base/R-3/R-3.6.0.tar.gz
tar -xvzf R-3.6.0.tar.gz
rm R-3.6.0.tar.gz

cd R-3.6.0
./configure --with-readline=no --with-x=yes --prefix=$INSTALL_DIR --enable-memory-profiling --enable-R-shlib --with-blas --with-lapack
make
make install

# Add R to the path.
export PATH=$INSTALL_DIR/bin:$PATH

# Install a bunch of packages:
Rscript -e 'install.packages("xml2", repos="http://cran.rstudio.com")'
Rscript -e 'install.packages("Cairo", repos="http://cran.rstudio.com")'
Rscript -e 'install.packages("rvest", repos="http://cran.rstudio.com")'
Rscript -e 'install.packages("knitr", repos="http://cran.rstudio.com")'
Rscript -e 'install.packages(c("data.table",
	"plotly", "crosstalk", "dplyr", "DT", "kableExtra",
	"formattable", "htmltools", "pander", "GGally", "shiny", "shinyWidgets"),
	repos="http://cran.rstudio.com")'

# Install git.
sudo apt-get install git
cd $HOME
# clone PHESANT library
git clone https://github.com/astheeggeggs/UKBB_ldsc_r2.git

# Move into the scripts folder and create the website.
cd UKBB_ldsc_r2/scripts/
Rscript render_site.r
