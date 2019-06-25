#\!/bin/bash
#$ -N copy_m
#$ -cwd
#$ -o /humgen/atgu1/fs03/dpalmer/logs/
#$ -w e
#$ -j y
#$ -b n
#$ -l h_vmem=2g
#$ -l h_rt=48:00:00

source /broad/software/scripts/useuse
# use GCC-5.2
# use GSL
# use UGER
# use Git-2.5
# use R-3.3
# use Anaconda
# reuse -q PLINK
# reuse -q .zlib-1.2.8
# reuse -q PSEQ
use .google-cloud-sdk

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/unix/ktashman/epi25/exec -l /bin/bash
gcloud init/google-cloud-sdk/path.bash.inc' ]; then source '/home/unix/ktashman/epi25/exec -l /bin/bash
gcloud init/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/unix/ktashman/epi25/exec -l /bin/bash
gcloud init/google-cloud-sdk/completion.bash.inc' ]; then source '/home/unix/ktashman/epi25/exec -l /bin/bash
gcloud init/google-cloud-sdk/completion.bash.inc'; fi

gsutil cp gs://ukbb-gwas-imputed-v3-results/export2/*.gwas.imputed_v3.male.tsv.bgz /psych/genetics_data/dpalmer/UKbb/sumstats-additive-export/males/
