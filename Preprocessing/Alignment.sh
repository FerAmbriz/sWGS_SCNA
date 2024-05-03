#############################################
#############################################
# Evaluar la calidad de la secuenciación usando fastqc
# Checar la página de https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
fastqc UEB_0205_CKDL210023209-1a-AK5431-AK5430_HGV3CCCX2_L4_*

# Crear un directorio para guardar los archivos de salida de fastqc
mkdir fastqc
mv *zip *html fastqc

#############################################
#############################################
# Alinear con bwa
# bwa mem -M -t 6 -R "@RG\tID:UEB_0205\tSM:UEB_0205\tPL:illumina\tPU:Lane1\tLB:WGS" /data/Lab13/ref/ucsc.hg19.fasta UEB_0205_CKDL210023209-1a-AK5431-AK5430_HGV3CCCX2_L4_1.fq.gz UEB_0205_CKDL210023209-1a-AK5431-AK5430_HGV3CCCX2_L4_2.fq.gz > UEB_0205.aligned.sam
#-------------------------------Script------------------------
#!/bin/bash
wait
bwa mem -M -t 6 -R "@RG\tID:UEB_0205\tSM:UEB_0205\tPL:illumina\tPU:Lane1\tLB:WGS" /data/Lab13/ref/ucsc.hg19.fasta UEB_0205_CKDL210023209-1a-AK5431-AK5430_HGV3CCCX2_L4_1.fq.gz UEB_0205_CKDL210023209-1a-AK5431-AK5430_HGV3CCCX2_L4_2.fq.gz > UEB_0205.aligned.sam
wait
echo done

#chmod 777 0214.sh
#nohup sh xxxx.sh > xxxx.out&
#------------------------------------------------------------

# Forma archivos .sam
bwa mem -M -t 3 -R "@RG\tID:UEB_0205\tSM:UEB_0205\tPL:illumina\tPU:Lane1\tLB:WGS" /home/fer/Documents/ref/ucsc.hg19.fasta UEB_0205_CKDL210023209-1a-AK5431-AK5430_HGV3CCCX2_L4_1.fq.gz UEB_0205_CKDL210023209-1a-AK5431-AK5430_HGV3CCCX2_L4_2.fq.gz > UEB_0205.aligned.sam

#midirectorio=$(pwd)
#docker run --rm -v $midirectorio:/data -it broadinstitute/gatk

docker run -v ~/Documents:/gatk/Documents -it broadinstitute/gatk
cd Documents

# Order los datos
gatk SortSam \
-I UEB_0205.aligned.sam \
-O UEB_0205.aligned.sorted.sam \
-SO coordinate

# Convertir sam a bam
gatk SamFormatConverter \
-I UEB_0205.aligned.sorted.sam \
-O UEB_0205.aligned.sorted.bam

# Marcar duplicados
gatk MarkDuplicates \
-I UEB_0205.aligned.sorted.bam \
-O UEB_0205.aligned.sorted.Dedup.bam  \
-M UEB_0205.aligned.sorted.Dedup.metrics.txt

# Construir el indice del bam
gatk BuildBamIndex -I UEB_0205.aligned.sorted.Dedup.bam

# Realizar el recalibramiento de bases

# gatk BaseRecalibrator \
#-R /data/Lab13/ref/ucsc.hg19.fasta \
#-I UEB_0205.aligned.sorted.Dedup.bam \
#--known-sites /data/Lab13/ref/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf \
#--known-sites /data/Lab13/ref/dbsnp_138.hg19.vcf \
#-O UEB_0205.recal.data.table


gatk BaseRecalibrator -R /gatk/Documents/ref/ucsc.hg19.fasta -I UEB_0205.aligned.sorted.Dedup.bam --known-sites /gatk/Documents/ref/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf --known-sites /gatk/Documents/ref/dbsnp_138.hg19.vcf -O UEB_0205.recal.data.table

# Aplicar el recalibramiento de bases

#atk ApplyBQSR \
#-R /data/Lab13/ref/ucsc.hg19.fasta \
#-I UEB_0205.aligned.sorted.Dedup.bam \
#--bqsr-recal-file UEB_0205.recal.data.table \
#-O UEB_0205.recal.reads.bam
gatk ApplyBQSR -R /gatk/Documents/ref/ucsc.hg19.fasta -I UEB_0205.aligned.sorted.Dedup.bam --bqsr-recal-file UEB_0205.recal.data.table -O UEB_0205.recal.reads.bam

#############################################
#############################################
# Generar ReadCountFile
readCounter UEB_0205.recal.reads.bam -b
# Generar el archivo wig
readCounter --window 100 --quality 20 --list \
--chromosome "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,X,Y" \
UEB_0205.recal.reads.bam > UEB_0205.wig

#############################################
#############################################
