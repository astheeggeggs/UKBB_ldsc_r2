#!/bin/bash

# Usage:
# bash submit_all_additive_r2.sh ldscore_files ldscore_files_weights sumstats_folder path_to_output start_at stop_at sumstats_folder_2 string_to_match

ldscore_files=$1; # "/psych/genetics_data/dpalmer/UKbb/MTAG_ld_ref_panel/eur_w_ld_chr/@"; These ones have to have the .ldscore format.
ldscore_files_weights=$2; # "/psych/genetics_data/dpalmer/UKbb/MTAG_ld_ref_panel/eur_w_ld_chr/@"; These ones have to have the .ldscore format.
sumstats_folder=$3; # "../../results/UKbb/ldsc-additive-export/sumstats-files-male";
path_to_output=$4; # "../../results/UKbb/ldsc-additive-export/correlation-results-across-sexes";
sumstats_folder_2=$7; # "../../results/UKbb/ldsc-additive-export/sumstats-files-female";
string_to_match=$8;

echo 'LD score files:' $1 
echo 'LD score weights files:' $2
echo 'sumstats folder:' $3
echo 'path to path_to_output:' $4
echo 'start at:' $5
echo 'stop at:' $6
echo 'sumstats folder 2:' $7
echo 'string to match:' $8

mkdir $path_to_output;

stop_at=$6;
start_at=$5;
done=0;

echo $sumstats_folder
shopt -s nullglob
array=($sumstats_folder/*)
shopt -u nullglob

# for sumstat_filename in $sumstats_folder/*; do
# 	# List all the sumstats in the folder and set to a comma delimited variable.
# 	if [ "$done" -ge "$start_at" ]; then
# 		phenotype=`echo $sumstat_filename | sed -e "s/^[\.\.//]*//" | sed -e "s/\..*//" | sed -e "s/^.*\///"`;
# 		current_array=("${array[@]:$done}")
# 		echo "creating phenotype files to pass"
# 		(IFS=,; echo "${current_array[*]}") | tr -d '\n' > "$path_to_output"/"$phenotype".r2.txt
# 		echo "created phenotype files to pass"
# 		# python2 ./ldsc.py --rg "$path_to_output"/"$phenotype".r2.txt --rg-file --ref-ld $ldscore_files --w-ld $ldscore_files --n-blocks 200 --out $path_to_output/$phenotype --write-rg
# 		qsub -v sumstat_files="$path_to_output"/"$phenotype".r2.txt,phenotype="$phenotype",ldscores_files="$ldscore_files",ldscores_files_weights="$ldscore_files_weights",out="$path_to_output" r2_additive_template.sh
# 		# Remove the current file from the folder
# 		echo "current lead sumstats file"
# 		echo "$phenotype".r2.txt
# 	fi
	
# 	let done++
# 	if [ "$done" -eq "$stop_at" ]; then
# 		break
# 	fi
# done

# This portion is for the stragglers that got killed due to uger errors

# for sumstat_filename in $sumstats_folder/*; do
# 	# List all the sumstats in the folder and set to a comma delimited variable.
# 	if [ "$sumstat_filename" = "$string_to_match" ]; then
# 		phenotype=`echo $sumstat_filename | sed -e "s/^[\.\.//]*//" | sed -e "s/\..*//" | sed -e "s/^.*\///"`;
# 		current_array=("${array[@]:$done}")
# 		echo "creating phenotype files to pass"
# 		(IFS=,; echo "${current_array[*]}") | tr -d '\n' > "$path_to_output"/"$phenotype".r2.txt
# 		echo "created phenotype files to pass"
# 		# python2 ./ldsc.py --rg "$path_to_output"/"$phenotype".r2.txt --rg-file --ref-ld $ldscore_files --w-ld $ldscore_files --n-blocks 200 --out $path_to_output/$phenotype --write-rg
# 		qsub -v sumstat_files="$path_to_output"/"$phenotype".r2.txt,phenotype="$phenotype",ldscores_files="$ldscore_files",ldscores_files_weights="$ldscore_files_weights",out="$path_to_output" r2_additive_template.sh
# 		# Remove the current file from the folder
# 		echo "current lead sumstats file"
# 		echo "$phenotype".r2.txt
# 	fi
# 	let done++
# done


# # This portion is to run the summary stat files that were rerun (in the males and females).
# done=0;
# for sumstat_filename in $sumstats_folder/*; do
# 	if [[ $sumstat_filename == *"v2"* ]]; then
#   		echo $sumstat_filename
#   		phenotype=`echo $sumstat_filename | sed -e "s/^[\.\.//]*//" | sed -e "s/\..*//" | sed -e "s/^.*\///"`;
#   		phenotype="$phenotype"_v2
# 		current_array=("${array[@]:$done}")
# 		echo "creating phenotype files to pass"
# 		echo $phenotype
# 		(IFS=,; echo "${current_array[*]}") | tr -d '\n' > "$path_to_output"/"$phenotype".r2.txt
# 		echo "created phenotype files to pass"
# 		# python2 ./ldsc.py --rg "$path_to_output"/"$phenotype"_v2.r2.txt --rg-file --ref-ld $ldscore_files --w-ld $ldscore_files --n-blocks 200 --out $path_to_output/$phenotype_v2 --write-rg
# 		qsub -v sumstat_files="$path_to_output"/"$phenotype".r2.txt,phenotype="$phenotype",ldscores_files="$ldscore_files",ldscores_files_weights="$ldscore_files_weights",out="$path_to_output" r2_additive_template.sh
# 		# Remove the current file from the folder
# 		echo "current lead sumstats file"
# 		echo "$phenotype".r2.txt
# 	fi
# 	let done++
# done

# echo $sumstats_folder
# shopt -s nullglob
# array=($sumstats_folder/*)
# shopt -u nullglob

# # This portion is to run the between sex genotype correlations

echo $sumstats_folder_2
shopt -s nullglob
# Get a list of all of the sumstat information in the other folder
array_2=($sumstats_folder_2/*)
shopt -u nullglob
done=0

# for sumstat_filename in $sumstats_folder/*; do
# 	# List all the sumstats in the folder and set to a comma delimited variable.
# 	if [ "$done" -ge "$start_at" ]; then
# 		# This is the normal behaviour (when not one of the phenotype repeats we had to run).
# 		phenotype=`echo $sumstat_filename | sed -e "s/^[\.\.//]*//" | sed -e "s/\..*//" | sed -e "s/^.*\///"`;
# 		# Rename the phenotype if it's the second run (after fixing).
# 		if [[ $sumstat_filename == *"v2"* ]]; then
# 			phenotype="$phenotype"_v2
# 		fi
# 		current_array=("${array[@]:$done:1}" "${array_2[@]}") # The current phenotype in this folder, and everything in the other folder.
# 		echo "creating phenotype files to pass"
# 		(IFS=,; echo "${current_array[*]}") | tr -d '\n' > "$path_to_output"/"$phenotype".r2.txt
# 		echo "created phenotype files to pass"
# 		# python2 ./ldsc.py --rg "$path_to_output"/"$phenotype".r2.txt --rg-file --ref-ld $ldscore_files --w-ld $ldscore_files --n-blocks 200 --out $path_to_output/$phenotype --write-rg
# 		qsub -v sumstat_files="$path_to_output"/"$phenotype".r2.txt,phenotype="$phenotype",ldscores_files="$ldscore_files",ldscores_files_weights="$ldscore_files_weights",out="$path_to_output" r2_additive_template.sh
# 		# Remove the current file from the folder
# 		echo "current lead sumstats file"
# 		echo "$phenotype".r2.txt
# 	fi
	
# 	let done++
# 	if [ "$done" -eq "$stop_at" ]; then
# 		break
# 	fi
# done


# This portion is for the stragglers that got killed due to uger errors

for sumstat_filename in $sumstats_folder/*; do
	# List all the sumstats in the folder and set to a comma delimited variable.
	if [ "$sumstat_filename" = "$string_to_match" ]; then
		phenotype=`echo $sumstat_filename | sed -e "s/^[\.\.//]*//" | sed -e "s/\..*//" | sed -e "s/^.*\///"`;
		current_array=("${array[@]:$done:1}" "${array_2[@]}") # The current phenotype in this folder, and everything in the other folder.
		echo "creating phenotype files to pass"
		(IFS=,; echo "${current_array[*]}") | tr -d '\n' > "$path_to_output"/"$phenotype".r2.txt
		echo "created phenotype files to pass"
		# python2 ./ldsc.py --rg "$path_to_output"/"$phenotype".r2.txt --rg-file --ref-ld $ldscore_files --w-ld $ldscore_files --n-blocks 200 --out $path_to_output/$phenotype --write-rg
		qsub -v sumstat_files="$path_to_output"/"$phenotype".r2.txt,phenotype="$phenotype",ldscores_files="$ldscore_files",ldscores_files_weights="$ldscore_files_weights",out="$path_to_output" r2_additive_template.sh
		# Remove the current file from the folder
		echo "current lead sumstats file"
		echo "$phenotype".r2.txt
	fi
	let done++
done





