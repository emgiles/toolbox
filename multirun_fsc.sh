#!/bin/bash

PREFIX="RECMIG"

for i in {1..15}
 do
   mkdir run$i
   cp ${PREFIX}.tpl ${PREFIX}.est ${PREFIX}_MSFS.obs run$i"/"
   cd run$i
   /mnt/HDD/programs/fsc28_linux64/fsc28 -t ${PREFIX}.tpl -e ${PREFIX}.est -m -0 -C 10 -n 200000 -L 40 -s0 -M -q -multiSFS
   cd ..
 done
