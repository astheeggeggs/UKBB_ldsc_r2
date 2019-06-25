#!/bin/bash

# Usage:
# bash combine_additive_r2_results.sh path_to_r2_folder file_to_write

path_to_r2_folder=$1;
file_to_write=$2;

echo $file_to_write;
echo -n > $file_to_write;

k=0;

for r2_filename in $path_to_r2_folder/*r2; do
	echo "$r2_filename concatenated";
	if [ "$k" -eq "0" ]; then
		cat $r2_filename >> $file_to_write;
	else
		tail -n +2 $r2_filename >> $file_to_write;
	fi
	let k++
done

# Remove the spaces introduced by the newline characters at the end of each file.
sed -i '/^[[:space:]]*$/d' $file_to_write
