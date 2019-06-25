library(data.table)
library(dplyr)

create_static_plots <- FALSE
save_widget <- FALSE

obtain_significant_correlations <- function(gzipped_file_to_read, output_filename, signif_h2_file, merge_with_pheno_corr=FALSE)
{
	# Read in the genetic correlations file.
	geno_corr_df <- fread(cmd = paste0("gzcat ", gzipped_file_to_read), key=c("p1","p2"))

	# Determine where the v2 versions are.
	where_v2_p1 <- grep('v2', geno_corr_df$p1)
	where_v2_p2 <- grep('v2', geno_corr_df$p2)

	to_remove_p1 <- c()
	to_remove_p2 <- c()

	if (length(where_v2_p1) > 0) {
		geno_corr_df$p1[where_v2_p1] <-  gsub("^.*\\/([^\\.]*)\\..*", "\\1_v2", geno_corr_df$p1[where_v2_p1])
		to_remove_p1 <- gsub("_v2", "", names(table(geno_corr_df$p1[where_v2_p1])))
	}

	if (length(where_v2_p2) > 0) {
		geno_corr_df$p2[where_v2_p2] <-  gsub("^.*\\/([^\\.]*)\\..*", "\\1_v2", geno_corr_df$p2[where_v2_p2])
		to_remove_p2 <- gsub("_v2", "", names(table(geno_corr_df$p2[where_v2_p2])))
	}

	geno_corr_df$p1 <- gsub("^.*\\/([^\\.]*)\\..*", "\\1", geno_corr_df$p1)
	geno_corr_df$p2 <- gsub("^.*\\/([^\\.]*)\\..*", "\\1", geno_corr_df$p2)

	# Now, remove the non-v2 versions.
	if( (length(to_remove_p1) > 0) | (length(to_remove_p2) > 0) ) {
		geno_corr_df <- geno_corr_df[-unique(c(which(geno_corr_df$p1 %in% to_remove_p1), which(geno_corr_df$p2 %in% to_remove_p2))),]
		# Rename the v2 versions.
		geno_corr_df$p1 <- gsub("_v2", "", geno_corr_df$p1)
		geno_corr_df$p2 <- gsub("_v2", "", geno_corr_df$p2)
	}

	setkeyv(geno_corr_df, c("p1", "p2"))

	if (merge_with_pheno_corr) {
		# Read in the phenotype correlation matrix
		pheno_corr <- as.matrix(fread(cmd = "gzcat ../r2_results/pheno_correlation.csv.gz") %>% select(-"V1"))
		# Get these in the same order as the first elements of geno_corr_df.
		names_row <- matrix(colnames(pheno_corr), nrow=nrow(pheno_corr), ncol=ncol(pheno_corr), byrow=FALSE)
		pheno_corr_df <- data.table(r2p=as.vector(pheno_corr), p2=as.vector(names_row), p1=as.vector(t(names_row)), key=c("p1","p2"))

		geno_pheno_df <- merge(geno_corr_df, pheno_corr_df, by=c("p1", "p2"), all=FALSE)
		setkeyv(geno_corr_df, c("p1", "p2"))
	} else {
		geno_pheno_df <- geno_corr_df
	}

	# Determine which of the rows and columns are in Raymond's list.
	signif_h2 <- fread(signif_h2_file, header=TRUE)

	# Read and merge in cleaned up descriptions that I manually curated.
	finngen_names <- fread("../inputs/ukb_finngen_names.tsv") %>% select(NAME, LONGNAME)
	names(finngen_names) <- c("phenotype", "cleaned_description")

	signif_h2_finn <- merge(signif_h2 %>% filter(source == 'finngen'), finngen_names, by='phenotype', all.x=TRUE) %>% filter(source == 'finngen')
	signif_h2_finn <- signif_h2_finn %>% mutate(description = cleaned_description) %>% select(-cleaned_description)
	signif_h2 <- merge(signif_h2 %>% filter(source != 'finngen'), signif_h2_finn, all=TRUE)

	# Remove those that start with C_
	to_remove <- names(which(table(gsub('^C3_', 'C_', signif_h2$phenotype)) > 1))
	signif_h2 <- signif_h2 %>% filter(!(phenotype %in% to_remove))

	sig_phenos_signif <- signif_h2[which((signif_h2$confidence %in% c("medium", "high")) & (signif_h2$h2_sig %in% c("z4", "z7"))),] %>% select(phenotype, description) %>% mutate(p1=phenotype, description_p1=description) %>% select(p1, description_p1)

	# This is stupid, but can't think of a better way.
	geno_pheno_df_restrict <- geno_pheno_df[.(sig_phenos_signif$p1), nomatch = 0L]
	setkey(geno_pheno_df_restrict, "p2")
	geno_pheno_df_restrict <- geno_pheno_df_restrict[.(sig_phenos_signif$p1), nomatch = 0L]
	setkey(geno_pheno_df_restrict, "p1")
	geno_pheno_df_restrict <- merge(geno_pheno_df_restrict, sig_phenos_signif, by='p1')
	sig_phenos_signif <- sig_phenos_signif %>% mutate(p2=p1, description_p2=description_p1) %>% select(p2, description_p2)
	geno_pheno_df_restrict <- merge(geno_pheno_df_restrict, sig_phenos_signif, by='p2')

	setkeyv(geno_pheno_df_restrict, c("p1","p2"))

	print(dim(geno_pheno_df_restrict))

	# The following files serves as input to a number of the plots displayed on the website.
	fwrite(geno_pheno_df_restrict, output_filename, sep='\t')
}

obtain_significant_correlations("../r2_results/geno_correlation.r2.gz", "../r2_results/geno_correlation_sig.r2", "../h2_results/ukb31063_topline_h2_4203_21_may_2019.tsv", merge_with_pheno_corr=TRUE)
obtain_significant_correlations("../r2_results/correlation_male.r2.gz", "../r2_results/geno_correlation_male_sig.r2", "../h2_results/ukb31063_topline_h2_4203_21_may_2019.tsv")
obtain_significant_correlations("../r2_results/correlation_female.r2.gz", "../r2_results/geno_correlation_female_sig.r2", "../h2_results/ukb31063_topline_h2_4203_21_may_2019.tsv")
obtain_significant_correlations("../r2_results/correlation_across_sexes.r2.gz", "../r2_results/geno_correlation_across_sexes_sig.r2", "../h2_results/ukb31063_topline_h2_4203_21_may_2019.tsv")
