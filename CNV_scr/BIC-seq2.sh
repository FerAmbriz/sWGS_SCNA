#MOntar contenedor docker
docker run -v ~/Documents:/BICSEQ2/Documents -it mwyczalkowski/bicseq2


cd /home/fer/Documents/Code/BICSEQ2/testing/direct_call/prep_mappability.demo.katmai

# Modificar el archivo project_config.demo.sh
# Mapibilidad
bash 1_test_mappability.sh
# Output in: BICSEQ2/Documents/Code/BICSEQ2/demo.out/map/ucsc.hg19.150mer/ (in docker) 
# /home/fer/Documents/Code/BICSEQ2/demo.out/map/ucsc.hg19.150mer

#Preparar la anotacion del gen
cd /home/fer/Documents/Code/BICSEQ2/testing/direct_call/run_sample.C3L-chr.katmai
# Modificar el documento y correrlo
bash a_prep_gene_annotation.sh

# Cambiar al otro directorio donde estan los ejemplos
cd /home/fer/Documents/Code/BICSEQ2/testing/direct_call/run_sample.C3L-chr.katmai

# Modificar el archivo project_config.run_sample.C3L-chr.katmai.sh y los otros scipts

bash a_prep_gene_annotation.sh
#Output in /data1/norm

bash 1_get_unique_reads.sh
#Output in /data1/unique_reads (in docker)

#Consume demasidada ram
bash 2_run_norm.sh



