#!/bin/bash

# Loop through all subdirectories starting with "scaffold"
find . -type d -name 'ld_sum*' | while read -r dir; do
  # Loop through all .txt files in each scaffold directory
  find "$dir" -type f -name '*.txt' | while read -r file; do
    echo "Processing $file"
    
    # Swap the first two lines and keep the rest as-is
    {
      read -r line1
      read -r line2
      echo "$line2"
      echo "$line1"
      cat
    } < "$file" > "${file}.tmp"

    # Remove the last line from the temporary file
    sed '$d' "${file}.tmp" > "${file}" && rm "${file}.tmp"
    
  done
done
