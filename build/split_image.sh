#!/usr/bin/env bash
set -euo pipefail

# split_image.sh
# Splits a large file into 4GB parts suitable for transfer over FAT32 or limited devices.
# Usage: ./build/split_image.sh <file> [chunk-size]
# Example: ./build/split_image.sh output/mega-os-s905x2-full.img.gz 4G

FILE=${1:-}
CHUNK_SIZE=${2:-4G}

if [ -z "$FILE" ]; then
  echo "Usage: $0 <file> [chunk-size]
Default chunk-size: 4G"
  exit 2
fi

if [ ! -f "$FILE" ]; then
  echo "File not found: $FILE"
  exit 3
fi

OUTDIR=$(dirname "$FILE")
BASE=$(basename "$FILE")

echo "Splitting $FILE into $CHUNK_SIZE parts in $OUTDIR"

pushd "$OUTDIR" >/dev/null
# split with numeric suffixes and make suffix length 3 (000..)
split -b "$CHUNK_SIZE" -d -a 3 "$BASE" "${BASE}.part"

echo "Created parts:"
ls -lh "${BASE}.part*" || true

echo "Generating SHA256 checksums..."
sha256sum "${BASE}.part"* > "${BASE}.parts.sha256"
ls -lh "${BASE}.parts.sha256"

popd >/dev/null

echo "Done. To reassemble on a Linux host: cat ${BASE}.part* > ${BASE}"
