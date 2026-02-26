#!/usr/bin/env bash
set -euo pipefail

# Recursively find matching fasta files
find . -type f -name "GCA*.fasta" ! -path "*busco*" -print0 | \
while IFS= read -r -d '' file
do
    # Get filename only
    filename="$(basename "$file")"

    # Extract basename before first dot
    base="${filename%%.*}"

    # Use directory of input file for output location
    dir="$(dirname "$file")"

    echo "Running Prokka on $file"
    echo "  Outdir: ${dir}/${base}_prokka"
    echo "  Prefix: ${base}"

    prokka \
        --outdir "${dir}/${base}_prokka" \
        --prefix "${base}" \
        "$file"

done
