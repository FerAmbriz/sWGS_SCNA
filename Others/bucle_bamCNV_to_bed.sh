#!/bin/bash

for i in freec_output/*.bam_CNVs;
do
				cut -f 1,2,3,5 $i > "${i%.recal*}".bed
done

mkdir freec_output/bed

mv freec_output/*.bed freec_output/bed
