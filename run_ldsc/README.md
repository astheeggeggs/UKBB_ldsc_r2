# Collection of scripts to run r^2 of everything for both_sexes, males and females.

Copy the ldsc output over from the UGER cluster using gsutil cp.
Run submit_all_additive_r2.sh for the sumstats files under consideration

both_sexes command run on files on the UGER cluser
`bash /home/unix/dpalmer/Repositories/ldscgxe/submission_scripts_uger/submit_all_additive_r2.sh /psych/genetics_data/dpalmer/UKbb/MTAG_ld_ref_panel/eur_w_ld_chr/@ /psych/genetics_data/dpalmer/UKbb/MTAG_ld_ref_panel/eur_w_ld_chr/@ /psych/genetics_data/dpalmer/UKbb/results/UKbb/ldsc-additive-export/sumstats-files /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/correlation-results start stop`

The following commands should be run from the Repositories/ldsc-master/ directory containing the modified ldsc code that allows generation of r2 files and reading in a file with a list of ldsc files to read in.

males command run on files on the UGER cluser
`bash /home/unix/dpalmer/Repositories/ldscgxe/submission_scripts_uger/submit_all_additive_r2.sh /psych/genetics_data/dpalmer/UKbb/MTAG_ld_ref_panel/eur_w_ld_chr/@ /psych/genetics_data/dpalmer/UKbb/MTAG_ld_ref_panel/eur_w_ld_chr/@ /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/sumstats-files-male /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/correlation-results-male start stop`

females command run on files on the UGER cluser
`bash /home/unix/dpalmer/Repositories/ldscgxe/submission_scripts_uger/submit_all_additive_r2.sh /psych/genetics_data/dpalmer/UKbb/MTAG_ld_ref_panel/eur_w_ld_chr/@ /psych/genetics_data/dpalmer/UKbb/MTAG_ld_ref_panel/eur_w_ld_chr/@ /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/sumstats-files-female /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/correlation-results-female start stop`

Once complete, combine the results together into a single file.
`bash combine_additive_r2_results.sh path_to_r2_folder file_to_write`

For both_sexes:
`bash /home/unix/dpalmer/combine_additive_r2_results.sh /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/correlation-results /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/correlation.r2`
For males:
`bash combine_additive_r2_results.sh /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/correlation-results-male /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/correlation_male.r2`
For females:
`bash combine_additive_r2_results.sh /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/correlation-results-female /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/correlation_female.r2`
For across the sexes
`bash combine_additive_r2_results.sh /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/correlation-results-across-sexes /psych/genetics_data/dpalmer/UKbb/ldsc-additive-export/correlation_across_sexes.r2`
