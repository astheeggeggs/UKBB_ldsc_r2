library(data.table)
library(dplyr)

dict <- fread("../inputs/Data_Dictionary_Showcase.csv")
dict$level2cat <- sapply(strsplit(as.character(dict$Path), split=' > '), `[`, 2)
dict$finallevelcat <- gsub(".*> ", "", as.character(dict$Path))

to_write <- dict %>% select("FieldID", "Field", "level2cat", "finallevelcat")

fwrite(to_write, "../inputs/Fields_and_categories.tsv", sep="\t")
