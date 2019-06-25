# UK Biobank LDSC Correlation Results

In this repository, we include all the necessary code and data to generate the UK Biobank LDSC correlation website.

## Data preparation and running LD score to determine genetic correlations

This consists of the following set of steps. 

1. Modify the ldsc code to receive comma delimited files to enumerate a large number of regression to perform. The slightly modified ldsc code is forked from the master branch.
2. Move all summary statistcs files from google cloud to the UGER cluster to run the collection of regressions.
3. Run all LD score correlations on the UGER cluster. This then results in a large number of results files that need to be cleaned and combined.
4. Combine the resultant files together.

Full details of these steps (including the exact commands and reference panels used) can be found in the separate README in the `run_ldsc` folder.

Note that a mirror of the results files used to generate these genetic correlation results can be found on the Nealelab website, shoud you want to regenerate or check the results for yourself!

The resulting large files consisting of all the results can be found in this repository in the results folder.

## Creating the website

Creating the website consists of two main components:

1. The static website
2. The shiny app which allows for interactive exploration of the results.

Unfortunately, in both cases the resultant files were too large to be hosted on github, so we host them on the hail website, but include all the code used to generate them here.

In the website, we restrict our attention to those phenotypes that were the most heritable and for which we have phenotypic correlation information. This is defined by looking into the file at `h2_results/ukb31063_topline_h2_4203.tsv` and defining significant phenotypes as those that have medium or high confidence and for whom the significance of $h^2$ is z4 or z7 - please see our heritability results for full details of the meaning of each of these metrics.

To do this, we use the script at `scripts/restrict_to_significant.r`. This generates a much smaller `.tsv` file which is found at `r2_results/geno_correlation_sig.r2` that can be read in quickly, data accessed and displayed on our website.

### Plotting correlation matrices and dimensionality reductions

1. Correlation matrix between all the significantly heritable phenotypes.
2. Correlation matrix between all the significantly heritable phenotypes and ordered using `hclust`.

For the following dimensionality reduction plots we also sought to colour categories of phenotypes and determine whether they cluster together. To do this we run the script `scripts/phenotype_categories_to_merge.r`. In this small script, we read in the data dictionary file supplied by UK Biobank (and included in the repository at `inputs/Data_Dictionary_Showcase.csv`), and consider the second level and final level of the `Path` column, and save the result to disk as `Fields_and_categories.tsv`. These are then merged in to define colours in the following plots.

3. PCA of the correlations of the significantly heritable phenotypes.
4. Diffusion map of the correlations of the significantly heritable phenotypes.
5. UMAP of the correlations of the significantly heritable phenotypes.

### Filling out the information for all of the significantly heritable phenotypes

To do this we first create an `Rdata` file containing all the information required for plotting and tables. This is essentially identical to `../r2_results/geno_correlation_sig.r2` but we include the upper diagonal of the corresponding correlation matrix that this represents to ensure that the phenotype columns contain all the phenotypes in the various tables that are produced.

This `Rdata` file is generated using the script at `scripts/generate_r2_results_Rdata.r`.

Using this `Rdata` file we then generate all of the phenotype specific pages.

A template of the file used can be found at  `site/rg_phenotype_template.Rmd`. We then loop over all phenotypes, using the script `scripts/render_site.r`. This script first renders all of the summary plots and then loops over each of the individual phenotypes.

### Creating the interactive table using the R package shiny

The final step is to then create the interactive table. To do this we use `shiny` in combination with the `DT` package in R. The `DT` package is a wrapper for certain functionality of the powerful `DataTables` package in javascript.

To generate the webpage, simply open R, ensure that the working directory is the `full_data_shiny_app` folder of this repository, load the shiny library and run `runApp()`.

To then deploy the website, we first set up an account at `shinyapps.io`. Once that is done, you can run `deployapp()` from the `rsconnect` library.

