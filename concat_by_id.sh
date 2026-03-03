#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./concat_by_id.sh "*.aln.fa" outdir
# Example:
#   ./concat_by_id.sh "alignments/*.aln.fa" concat_out

PATTERN="${1:-*.aln.fa}"
OUTDIR="${2:-concat_out}"

mkdir -p "$OUTDIR"

# Expand the pattern into a file list
shopt -s nullglob
FILES=( $PATTERN )
shopt -u nullglob

if (( ${#FILES[@]} == 0 )); then
  echo "ERROR: No files matched pattern: $PATTERN" >&2
  exit 1
fi

awk -v outdir="$OUTDIR" '
BEGIN { FS="\n"; RS=">"; ORS="" }

NR>1 {
    header=$1
    seq=""
    for (i=2; i<=NF; i++) seq=seq $i

    split(header, a, "_")
    id=a[1]

    concat[id]=concat[id] seq
}

END {
    for (id in concat) {
        fn = outdir "/" id ".concatenated.fasta"
        print ">" id "\n" concat[id] "\n" > fn
        close(fn)
    }
}
' "${FILES[@]}"

echo "Wrote one concatenated FASTA per ID into: $OUTDIR"
echo "Example output: $OUTDIR/<ID>.concatenated.fasta"
