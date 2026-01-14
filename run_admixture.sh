#!/bin/bash

# Define the base command
base_command="/home/scientist/miniconda3/envs/pop_gen/bin/admixture --cv /mnt/HDD/users/Emily/Giant_Kelp/2025_06_10/KELP-25-01-9858861/BCLConvert_06_05_2025_04_13_23Z-14437429/03_PCA/round5/filtered_giant_kelp_pileup_called_NZonly_final_variant.LDpruned.bed"

# Loop from 1 to 10
for i in {1..10}; do
    # Define the log file name for this iteration
    log_file="run_${i}.log"
    
    # Execute the command with the current value of i, and redirect output to the log file
    eval "$base_command $i > $log_file 2>&1"
    
    # Output a message to indicate the completion of the iteration
    echo "Iteration $i completed. Log saved to $log_file"
done
