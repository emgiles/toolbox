#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 sample_info.tsv input.fasta output.fasta" >&2
  echo "  sample_info.tsv must have columns: seq_ID_partial, location, site" >&2
  exit 1
fi

tsv="$1"
fasta_in="$2"
fasta_out="$3"

awk -F'\t' -v OFS="\t" '
# Normalize header names: strip BOM/CR, lowercase, remove non [a-z0-9_]
function normname(s,   bom){
  gsub(/\r/,"",s)
  bom = sprintf("%c%c%c",239,187,191)   # UTF-8 BOM
  sub("^" bom, "", s)
  s = tolower(s)
  gsub(/[^a-z0-9_]+/,"",s)
  return s
}

# -------- Pass 1: read TSV into maps keyed by seq_ID_partial --------
FNR==NR {
  if (FNR==1) {
    for (i=1; i<=NF; i++) {
      name = normname($i)
      if (name=="seq_id_partial") ci=i
      else if (name=="location")  li=i
      else if (name=="site")      si=i
    }
    if (!ci || !li || !si) {
      print "ERROR: TSV must contain header with columns: seq_ID_partial, location, site" > "/dev/stderr"
      exit 2
    }
    next
  }
  key = $ci
  loc[key]  = $li
  site[key] = $si
  next
}

# -------- Pass 2: process FASTA --------
BEGIN { RS=">"; ORS="" }
NR==1 { next }   # skip preface before first header

{
  # split record into header and sequence (keep original wrapping)
  nl  = index($0, "\n")
  hdr = substr($0, 1, nl-1)
  seq = substr($0, nl+1)

  # Take first whitespace-delimited token
  n = split(hdr, a, /[ \t]/)
  tok = a[1]

  # 1) strip any leading path
  key = tok
  sub(/^.*\//, "", key)

  # 2) keep up to FIRST dot, if present (else keep whole token)
  dot = index(key, ".")
  if (dot > 0) key = substr(key, 1, dot-1)

  # Look up in TSV and append location/site if matched
  if (key in loc) {
    newhdr = hdr " location=" loc[key] " site=" site[key]
  } else {
    newhdr = hdr
  }

  print ">", newhdr, "\n", seq
}
END{
  if (!ci || !li || !si) {
    print "ERROR: TSV must contain header with columns: seq_ID_partial, location, site" > "/dev/stderr"
    exit 2
  }
}
' "$tsv" "$fasta_in" > "$fasta_out"

