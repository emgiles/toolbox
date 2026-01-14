#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 input.fasta output.fasta"
  exit 1
fi

in="$1"
out="$2"

awk '
BEGIN { RS=">"; ORS="" }
NR==1 { next }  # skip preamble before first header
{
  # Split record into header and sequence
  nl = index($0, "\n")
  hdr = substr($0, 1, nl-1)
  seq = substr($0, nl+1)

  # Get first token of header (up to first whitespace)
  n = split(hdr, a, /[ \t]/)
  tok = a[1]

  # Sample key = token with anything from ".bam" onward removed
  # (handles headers like: SAMPLE.bam, SAMPLE.bam:suffix, SAMPLE.bam-etc)
  key = tok
  sub(/\.bam.*/, "", key)

  # If no .bam, key stays as token
  if (!(key in seen)) {
    seen[key] = 1
    print ">", hdr, "\n", seq
  }
}
' "$in" > "$out"

