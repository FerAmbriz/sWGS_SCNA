cd /home/fer/Documents/cfDNA/UEB_0205

# Build BAM index for file
/home/fer/Programs/hmmcopy_utils/bin/readCounter UEB_0205.recal.reads.bam -b

#/home/fer/hmmcopy_utils/bin/readCounter --window 1000000 --quality 20 -b --chromosome "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,X,Y" /home/fer/Documents/fasq/UEB_0205/UEB_0205.recal.reads.bam > UEB_0205.recal.reads.wig

/home/fer/hmmcopy_utils/bin/readCounter --window 1000000 --quality 20 --chromosome "chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY" /home/fer/Documents/cfDNA/UEB_0205/UEB_0205.recal.reads.bam > UEB_0205.recal.reads.wig

###------------------------------ alt -----------------------------
docker run -v ~/Documents:/gatk/Documents -it broadinstitute/gatk
var=$(samtools idxstats UEB_0205.recal.reads.bam|cut -f 1)

echo $var
exit

### -----------------------------------------------------------------

mkdir ichorCNA

# Run ichorCNA
# --normal = Fracción no tumoral
# --ploidy "c(2)" diploide
# --maxCN 3 = Reduce el numero de estados de copias
# --estimateScPrevalence False == No tiene en cuenta los eventos del numero de copia subclonal
# --scStates refers to subclonal copy number states - 1 (deletion) and 3 (gain) subclonal states are included. 
# --includeHOMD False =  No se incluye deleción homocigota

# --txnE = Ajuste de sensitividad
# higher (e.g. 0.9999999) leads to higher specificity and fewer segments
# lower (e.g. 0.99) leads to higher sensitivity and more segments

# --txnStrength = control del numero de segmentos
# higher (e.g. 10000000) leads to higher specificity and fewer segments
# lower (e.g. 100) leads to higher sensitivity and more segments

Rscript /home/fer/Programs/ichorCNA/scripts/runIchorCNA.R --id UEB_0205 \
  --WIG UEB_0205.recal.reads.wig --ploidy "c(2)" --normal "c(0.95, 0.99, 0.995, 0.999)" --maxCN 5 \
  --gcWig /home/fer/Programs/ichorCNA/inst/extdata/gc_hg19_1000kb.wig \
  --mapWig /home/fer/Programs/ichorCNA/inst/extdata/map_hg19_1000kb.wig \
  --centromere /home/fer/Programs/ichorCNA/inst/extdata/GRCh37.p13_centromere_UCSC-gapTable.txt \
  --normalPanel /home/fer/Programs/ichorCNA/inst/extdata/HD_ULP_PoN_1Mb_median_normAutosome_mapScoreFiltered_median.rds \
  --includeHOMD False --chrs "c(1:22, \"X\")" --chrTrain "c(1:22)" \
  --estimateNormal True --estimatePloidy True --estimateScPrevalence True \
  --scStates "c(1,3)" --txnE 0.9999 --txnStrength 10000 --outDir ichorCNA




#---------------Bueno-------------------
readCounter UEB_0213.recal.reads.bam -b

readCounter --window 500000 --quality 20 --chromosome "chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY" UEB_0213.recal.reads.bam > UEB_0213.recal.reads.wig

Rscript /home/fer/Programs/ichorCNA/scripts/runIchorCNA.R --id UEB_0213 \
	 --WIG UEB_0213.recal.reads.wig --ploidy "c(2)" --normal "c(0.9, 0.99, 0.995, 0.999)" --maxCN 3 \
	 --gcWig /home/fer/Programs/ichorCNA/inst/extdata/gc_hg19_500kb.wig \
	 --mapWig /home/fer/Programs/ichorCNA/inst/extdata/map_hg19_500kb.wig\
	 --centromere /home/fer/Programs/ichorCNA/inst/extdata/GRCh37.p13_centromere_UCSC-gapTable.txt \
	 --normalPanel /home/fer/Programs/ichorCNA/inst/extdata/HD_ULP_PoN_500kb_median_normAutosome_mapScoreFiltered_median.rds \
	 --includeHOMD False --chrs "c(1:3)" --chrTrain "c(1:3)" \
	 --estimateNormal True --estimatePloidy True --estimateScPrevalence False \
	 --scStates "c(1,3)" --txnE 0.9999 --txnStrength 10000 --outDir ichorCNA
