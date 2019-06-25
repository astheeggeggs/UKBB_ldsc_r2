require("rmarkdown")

# build
render_site()

# yaml for per-pheno sites
load("../shiny_app/geno_corr_no_irnt_label.Rdata")
pheno <- unique(geno_corr_df$p1)

for(i in pheno) {
	render('../rg_phenotype_template.Rmd', params=list(pheno=i, dat='shiny_app/geno_corr_no_irnt_label.Rdata'),
		output_file=paste0('rg_summary_', i, '.html'), output_dir='../docs')
}
