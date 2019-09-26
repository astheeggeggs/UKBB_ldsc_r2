library(data.table)
library(dplyr)

create_corr_Rdata <- function(r2_file, out, h2_of_first_phenotype)
{
	geno_corr_df <- fread(r2_file)
	geno_corr_df$p1 <- gsub("_irnt", "", geno_corr_df$p1)
	geno_corr_df$p2 <- gsub("_irnt", "", geno_corr_df$p2)
	setkeyv(geno_corr_df, c("p1", "p2"))

	key_values <- geno_corr_df %>% filter(p1==geno_corr_df$p1[1]) %>% select('p2', 'h2_obs', 'h2_obs_se', 'h2_int', 'h2_int_se')
	key_values <- rbind(h2_of_first_phenotype, key_values)
	geno_corr_df2 <- geno_corr_df %>% mutate(p1_tmp = p2, p2=p1, description_p1_tmp = description_p2, description_p2 = description_p1) %>% mutate(p1 = p1_tmp, description_p1 = description_p1_tmp) %>% select(-c(p1_tmp, description_p1_tmp))
	
	j <- 1
	for (i in key_values$p2) {
		geno_corr_df2[which(geno_corr_df2$p2 == i), c('h2_obs', 'h2_obs_se', 'h2_int', 'h2_int_se')] <- key_values[j, c('h2_obs', 'h2_obs_se', 'h2_int', 'h2_int_se')]
		j <- j+1
	}
	geno_corr_df <- rbind(geno_corr_df, geno_corr_df2)
	setkeyv(geno_corr_df, c("p1", "p2"))

	save(geno_corr_df, file=out)
}

create_corr_Rdata("../r2_results/geno_correlation_sig.r2", "../Rdata_outputs/geno_correlation_sig.Rdata",
	c('100001', strsplit(system('gzcat ../r2_results/geno_correlation.r2.gz | head -2', intern=TRUE)[2][[1]], split = '\\s+')[[1]][7:10]))
create_corr_Rdata("../r2_results/geno_correlation_male_sig.r2", "../Rdata_outputs/geno_correlation_male_sig.Rdata",
	c('100001', strsplit(system('gzcat ../r2_results/correlation_male.r2.gz | head -2', intern=TRUE)[2][[1]], split = '\\s+')[[1]][7:10]))
create_corr_Rdata("../r2_results/geno_correlation_female_sig.r2", "../Rdata_outputs/geno_correlation_female_sig.Rdata",
	c('100001', strsplit(system('gzcat ../r2_results/correlation_female.r2.gz | head -2', intern=TRUE)[2][[1]], split = '\\s+')[[1]][7:10]))
create_corr_Rdata("../r2_results/geno_correlation_across_sexes_sig.r2", "../Rdata_outputs/geno_correlation_across_sexes_sig.Rdata",
	c('100001', strsplit(system('gzcat ../r2_results/correlation_across_sexes.r2.gz | head -2', intern=TRUE)[2][[1]], split = '\\s+')[[1]][7:10]))
