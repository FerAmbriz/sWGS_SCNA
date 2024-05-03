#!/bin/bash

array=($(ls /home/fer/Documents/cfDNA/bam_data/*.bam))
tLen=${#array[@]}

for (( i=0; i<${tLen}; i=i+1));
do

a=${array[$i]}
b=${a%.recal*}
b=${b##*/}

cat << EOF > scripts/${b%.*}.txt 

[general]

chrLenFile = /home/fer/Documents/ref/ucsc.hg19.fasta.fai
ploidy = 2
window = 50000
chrFiles = /home/fer/Documents/ref/ref_chr
outputDir = freec_output

gemMappabilityFile = /home/fer/Documents/Code/cfDNA/FREEC_data/ucsc.hg19.gem

[sample]

mateFile = $a
inputFormat = BAM
mateOrientation = RF

EOF

done
