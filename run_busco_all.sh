#!/usr/bin/env bash

# Usage:
#   ./run_busco_recursive.sh /path/to/subdirectory
# If no path is provided, the current directory is used.

SEARCH_DIR="${1:-.}"

find "$SEARCH_DIR" -type f -name "*.fna" -print0 | while IFS= read -r -d '' file
do
    dir="$(dirname "$file")"
    base="$(basename "$file" .fna)"

    echo "Running BUSCO on: $file"

    busco \
        -i "$file" \
        -l piscirickettsiaceae_odb12 \
        -m genome \
        -o "${base}_busco_piscirickettsiaceae" \
        --out_path "$dir"

done
