#!/bin/bash

# To run
#bash GenType.sh /home/fer/Documents/cfDNA/Programs/FREEC/tsv csv_filtered

array=($(ls $1/*.tsv))
tLen=${#array[@]}

for (( i=0; i<${tLen}; i=i+1));
do
python InterGenType.py ${array[$i]} $2

done
awk '(NR == 1) || (FNR > 1)' $2/*.csv > merge.csv
