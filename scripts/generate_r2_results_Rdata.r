library(data.table)
library(dplyr)

create_corr_Rdata <- function(r2_file, out)
{
	geno_corr_df <- fread(r2_file)
	geno_corr_df$p1 <- gsub("_irnt", "", geno_corr_df$p1)
	geno_corr_df$p2 <- gsub("_irnt", "", geno_corr_df$p2)
	setkeyv(geno_corr_df, c("p1", "p2"))

	geno_corr_df2 <- geno_corr_df %>% mutate(p1_tmp = p2, p2=p1, description_p1_tmp = description_p2, description_p2 = description_p1) %>% mutate(p1 = p1_tmp, description_p1 = description_p1_tmp) %>% select(-c(p1_tmp, description_p1_tmp))
	geno_corr_df <- rbind(geno_corr_df, geno_corr_df2)
	setkeyv(geno_corr_df, c("p1", "p2"))

	save(geno_corr_df, file=out)
}

create_corr_Rdata("../r2_results/geno_correlation_sig.r2", "../Rdata_outputs/geno_correlation_sig.Rdata")
create_corr_Rdata("../r2_results/geno_correlation_male_sig.r2", "../Rdata_outputs/geno_correlation_male_sig.Rdata")
create_corr_Rdata("../r2_results/geno_correlation_female_sig.r2", "../Rdata_outputs/geno_correlation_female_sig.Rdata")
create_corr_Rdata("../r2_results/geno_correlation_across_sexes_sig.r2", "../Rdata_outputs/geno_correlation_across_sexes_sig.Rdata")
