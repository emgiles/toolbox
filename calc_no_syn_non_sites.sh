#!/bin/bash

# Define the input CSV file and the output CSV file
input_file="transcript-counts.tsv"
output_file="transcript-counts-syn-non.tsv"

# Use awk to process the input file and add the new columns
awk -F'\t' 'BEGIN {OFS="\t"}
NR == 1 {
    # Print the header and add the new column names
    print $0, "no_syn_sites", "no_nonsyn_sites"
} 
NR > 1 {
    # Calculate the no_syn_sites value
    no_syn_sites = $8 + (3/4) * $7 + (2/4) * $6
    # Calculate the no_nonsyn_sites value
    no_nonsyn_sites = (1/4) * $7 + (2/4) * $6 + $5
    # Print the original line and the new column values
    print $0, no_syn_sites, no_nonsyn_sites
}' "$input_file" > "$output_file"

echo "New columns added to $output_file"
