#!/bin/bash
for i in $1/*.tsv;
do
python InterGenType.py $i $2
done;

awk '(NR == 1) || (FNR > 1)' $2/*.csv > $2/merge.csv

echo ' '
echo 'Merge done'

python Oncoprint.py $2
