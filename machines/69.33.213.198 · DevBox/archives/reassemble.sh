#!/bin/bash
# Reassemble every split archive in this directory, then verify SHA256SUMS.
set -e
cd "$(dirname "$0")"
for base in $(ls *.tar.gz.part-* 2>/dev/null | sed -E 's/\.part-[0-9]+$//' | sort -u); do
  echo "reassembling $base"
  cat "$base".part-* > "$base"
done
sha256sum -c SHA256SUMS
echo "done"
