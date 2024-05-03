library(QDNAseq)
# future::plan("multisession", workers=3)

# Selección del tamaño de bins
bins <- getBinAnnotations(binSize=15)

#readCounts <- binReadCounts(bins, path="/home/fer/Documents/bam/QIAGEN")

# Carga de bam files
readCounts <- binReadCounts(bins, path="/home/fer/Documents/cfDNA/UEB_0205")

# Muestras sin procesar
plot(readCounts, logTransform=FALSE, ylim=c(-50, 200))

# Para incluir cromosomas sexuales [No recomendado]
# readCounts <- applyFilters(readCounts, chromosomes=NA)




# Aplicar filtros del contenido de GC y capacidad de mapeo
readCountsFiltered <- applyFilters(readCounts, residual=TRUE, blacklist=TRUE)
#readCountsFiltered <- applyFilters(readCounts, residual=TRUE, blacklist=TRUE, chromosomes=c(1:3, 5:13, 15:16, 18:22))
isobarPlot(readCountsFiltered)




# Estimación de colrección del contenido de mapeabilidad y contenido de GC
readCountsFiltered <- estimateCorrection(readCountsFiltered)
# Relación entre la DE y su profundidad de lectura
noisePlot(readCountsFiltered)

# Aplicar la corrección estimada
copyNumbers <- correctBins(readCountsFiltered)
# Normalizado
copyNumbersNormalized <- normalizeBins(copyNumbers)
# Suavizado
copyNumbersSmooth <- smoothOutlierBins(copyNumbersNormalized)
plot(copyNumbersSmooth)

# Exportar archivos para realizar un analisis en IGV
# exportBins(copyNumbersSmooth, file="LGG150.txt")
# exportBins(copyNumbersSmooth, file="LGG150.igv", format="igv")
# exportBins(copyNumbersSmooth, file="LGG150.bed", format="bed")

# Segmentación con el algoritmo CBS de DNAcopy y llamadas de CNV con CCGcall
copyNumbersSegmented <- segmentBins(copyNumbersSmooth, transformFun="sqrt")

# Iterar este comando hasta que se este satisfecho
copyNumbersSegmented <- normalizeSegmentedBins(copyNumbersSegmented)
plot(copyNumbersSegmented)

#copyNumbers <- callBins(..., ncpus=4)
# Si CGCcall falla callBins puede realizar llamadas simples
copyNumbersCalled <- callBins(copyNumbersSegmented)
plot(copyNumbersCalled)
#---------------------------Graficar---------------------------
#par(mfcol = c(2, 2))

#plot(copyNumbersCalled, pointcol="#696969", segcol="green", pointcex=getOption("QDNAseq::pointcex", 0.5))

#plot(copyNumbersCalled, pointcol="#696969", segcol="green", pointcex=getOption("QDNAseq::pointcex"))

#plot(copyNumbersCalled, pointcol="#696969", segcol="green", pointcex=getOption("QDNAseq::pointcex"))

#plot(copyNumbersCalled, pointcol="#696969", segcol="green", pointcex=getOption("QDNAseq::pointcex"))

#-------------------------------------------------------------
# Exportar los datos a VCF o SEG
exportBins(copyNumbersCalled,file="CNV.vcf", format="vcf")
# exportBins(copyNumbersCalled, format="seg")

# Para analisis posteriores como regiones de CGH, podria ser util convertir las CNV en un objeto cgh
#cgh <- makeCgh(copyNumbersCalled)

