#!/usr/bin/env bash
set -euo pipefail

# join_image.sh
# Reassembles parts produced by split_image.sh
# Usage: ./build/join_image.sh <first-part>
# Example: ./build/join_image.sh output/mega-os-s905x2-full.img.gz.part000

FIRST_PART=${1:-}

if [ -z "$FIRST_PART" ]; then
  echo "Usage: $0 <first-part>"
  exit 2
fi

DIR=$(dirname "$FIRST_PART")
BASE=$(basename "$FIRST_PART")

# Extract base prefix by removing .partNNN
PREFIX=${BASE%.*}

OUT="${DIR}/${PREFIX}"

echo "Reassembling parts starting with $FIRST_PART into $OUT"
pushd "$DIR" >/dev/null
cat "${PREFIX}.part"* > "$OUT"
echo "Verifying checksums (if present)"
if [ -f "${PREFIX}.parts.sha256" ]; then
  sha256sum -c "${PREFIX}.parts.sha256" || echo "Warning: checksum verification failed"
fi
popd >/dev/null

echo "Done: $OUT"
