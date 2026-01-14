#!/bin/bash

FILE=all_samples_filtrado_final.recode.LDpruned_reduced.vcf.recode_124indv.vcf.recode

for i in {0..5}
do
treemix -i $FILE.treemix.frq.gz -m $i -o $FILE.$i -bootstrap -k 500 -root scurra > treemix_${i}_log &
done
