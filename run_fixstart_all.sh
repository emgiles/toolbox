#!/usr/bin/env bash
set -euo pipefail

# Search recursively, excluding any path containing "busco"
find . -type f -name "*.fna" ! -path "*busco*" -print0 | \
while IFS= read -r -d '' file
do
    dir="$(dirname "$file")"
    base="$(basename "$file" .fna)"

    echo "Processing: $file"

    circlator fixstart \
        "$file" \
        "$dir/${base}_fixstart"

done
