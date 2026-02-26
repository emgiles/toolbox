#!/usr/bin/env bash
set -euo pipefail

for file in *.fasta; do
    # Skip if no fasta files found
    [[ -e "$file" ]] || { echo "No .fasta files found"; exit 1; }

    # Extract basename before first underscore
    base="${file%%_*}"

    echo "Running Prokka on $file"
    echo "  Outdir: ${base}_prokka"
    echo "  Prefix: ${base}"

    prokka \
        --outdir "${base}_prokka" \
        --prefix "${base}" \
        "$file"

done
