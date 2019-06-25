#\!/bin/bash
#$ -N run_h2_pheno
#$ -cwd
#$ -o /psych/genetics_data/dpalmer/logs/
#$ -w e
#$ -j y
#$ -b n
#$ -l h_vmem=12g
#$ -l h_rt=48:00:00

source /broad/software/scripts/useuse
use GCC-5.2
use GSL
use UGER
use Git-2.5
use R-3.3
use Anaconda
reuse -q PLINK
reuse -q .zlib-1.2.8
reuse -q PSEQ

# pip install --user bitarray
# pip install --user pandas --upgrade
conda env create --file environment.yml
source activate ldsc
./ldsc.py --rg $sumstat_files --rg-file --ref-ld-chr $ldscores_files --w-ld-chr $ldscores_files --n-blocks 200 --out $out/$phenotype --write-rg