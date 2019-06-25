require("rmarkdown")

# build
setwd("../site")
rmarkdown::render_site()

# yaml for per-pheno sites
load("../Rdata_outputs/geno_correlation_sig.Rdata")
pheno <- unique(geno_corr_df$p1)
load("../Rdata_outputs/geno_correlation_male_sig.Rdata")
pheno <- unique(c(pheno, geno_corr_df$p1))
load("../Rdata_outputs/geno_correlation_female_sig.Rdata")
pheno<- unique(c(pheno, geno_corr_df$p1))

for(i in pheno) {
	render('../site/rg_phenotype_template.Rmd', params=list(pheno=i, dat='../Rdata_outputs/geno_correlation_sig.Rdata',
		dat_male="../Rdata_outputs/geno_correlation_male_sig.Rdata", dat_female="../Rdata_outputs/geno_correlation_female_sig.Rdata"),
		output_file=paste0('rg_summary_', i, '.html'), output_dir='../docs')
}

dat <- c("../r2_results/geno_correlation_male_sig.r2", "../r2_results/geno_correlation_female_sig.r2")
sex <- c("Males,", "Females,")
sex_file <- c("male", "female")
for(i in 1:2)
{
	render('../site/correlation_plots.Rmd', params=list(sex=sex[i], dat=dat[i]),
		output_file=paste0('correlation_plots_', sex_file[i], '.html'), output_dir='../docs')

	render('../site/correlation_plots_agglo.Rmd', params=list(sex=sex[i], dat=dat[i]),
		output_file=paste0('correlation_plots_agglo_', sex_file[i], '.html'), output_dir='../docs')
}
