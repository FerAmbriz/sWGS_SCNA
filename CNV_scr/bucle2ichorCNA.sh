for i in /home/fer/Documents/cfDNA/bam_data/*.bam;
do

mkdir "${i%.rec*}"
				# Index *.bam.bai
readCounter $i -b
				# Make a wig file 500kb
readCounter --window 500000 --quality 20 --chromosome "chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY" $i > "${i%.rec*}".wig

#ichorCNA
ID="${i%.rec*}"
ID=${ID##*/}

Rscript /home/fer/Programs/ichorCNA/scripts/runIchorCNA.R --id $ID \
				--WIG "${i%.rec*}".wig --ploidy "c(2)" --normal "c(0.9, 0.99, 0.995, 0.999)" --maxCN 3 \
				--gcWig /home/fer/Programs/ichorCNA/inst/extdata/gc_hg19_500kb.wig \
				--mapWig /home/fer/Programs/ichorCNA/inst/extdata/map_hg19_500kb.wig\
				--centromere /home/fer/Programs/ichorCNA/inst/extdata/GRCh37.p13_centromere_UCSC-gapTable.txt \
				--normalPanel /home/fer/Programs/ichorCNA/inst/extdata/HD_ULP_PoN_500kb_median_normAutosome_mapScoreFiltered_median.rds \
				--includeHOMD False --chrs "c(1:22, \"X\")" --chrTrain "c(1:22)" \
				--estimateNormal True --estimatePloidy True --estimateScPrevalence False \
				--scStates "c(1,3)" --txnE 0.9999 --txnStrength 10000 --outDir "${i%.rec*}"

done
