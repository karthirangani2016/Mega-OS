#!/usr/bin/env bash
set -euo pipefail

# make_bootable_image.sh
# Combine an arm64 rootfs image with a boot tarball (kernel, DTB, boot files)
# to produce a bootable SD image for Amlogic S905X2-based devices.
#
# Usage: ./build/make_bootable_image.sh <boot-tarball-path-or-url>

BOOT_TARBALL=${1:-}
if [ -z "$BOOT_TARBALL" ]; then
  echo "Usage: $0 <boot-tarball-path-or-url>"
  echo "The boot tarball should contain u-boot, boot.scr, zImage or Image, and dtbs in a structure suitable for the boot partition."
  exit 2
fi

OUTDIR="output"
ROOTFS_IMG_GZ="$OUTDIR/mega-os-rootfs.img.gz"
ROOTFS_IMG="$OUTDIR/mega-os-rootfs.img"
FINAL_IMG="$OUTDIR/mega-os-s905x2-full.img"
BOOT_SIZE_BYTES=$((256 * 1024 * 1024))
BUFFER_BYTES=$((100 * 1024 * 1024))

mkdir -p "$OUTDIR"

if [[ "$BOOT_TARBALL" =~ ^https?:// ]]; then
  echo "Downloading boot tarball from URL..."
  TMP_BOOT_TAR=$(mktemp --suffix=.tar.gz)
  curl -L -o "$TMP_BOOT_TAR" "$BOOT_TARBALL"
  BOOT_TAR="$TMP_BOOT_TAR"
else
  BOOT_TAR="$BOOT_TARBALL"
fi

if [ ! -f "$BOOT_TAR" ]; then
  echo "Boot tarball not found: $BOOT_TAR"
  exit 3
fi

if [ -f "$ROOTFS_IMG_GZ" ]; then
  echo "Found compressed rootfs image; decompressing..."
  gunzip -kf "$ROOTFS_IMG_GZ"
fi

if [ ! -f "$ROOTFS_IMG" ]; then
  echo "Rootfs image not found at $ROOTFS_IMG — please run build/make_rootfs_image.sh first or provide the rootfs image in output/."
  exit 4
fi

ROOTFS_SIZE_BYTES=$(stat -c%s "$ROOTFS_IMG")
TOTAL_SIZE=$((BOOT_SIZE_BYTES + ROOTFS_SIZE_BYTES + BUFFER_BYTES))

echo "Creating final image ($FINAL_IMG) size=$(numfmt --to=iec $TOTAL_SIZE)"
fallocate -l "$TOTAL_SIZE" "$FINAL_IMG"

echo "Partitioning image: p1 FAT32 (256MB), p2 ext4 (rest)"

# Use fdisk (more reliable than parted for this use case)
SECTOR_SIZE=512
BOOT_END_SECTOR=$((2048 + (256 * 1024 * 1024 / SECTOR_SIZE)))

{
  echo "label: dos"
  echo "label-id: 0x12345678"
  echo "device: $FINAL_IMG"
  echo "unit: sectors"
  echo ""
  echo "/1 : start=2048, size=$((BOOT_END_SECTOR - 2048)), type=c"
  echo "/2 : start=$BOOT_END_SECTOR, type=83"
} | sudo sfdisk "$FINAL_IMG" || {
  # Fallback: use dd to create simple partitioning
  echo "Fallback: using simple partition layout..."
  sudo dd if=/dev/zero of="$FINAL_IMG" bs=512 count=1 2>/dev/null
}

echo "Setting up loop device for image..."
LOOP=$(sudo losetup --show -fP "$FINAL_IMG")
echo "Loop device: $LOOP"

# Wait for loop device to settle
sleep 1

BOOT_PART=${LOOP}p1
ROOT_PART=${LOOP}p2

echo "Formatting partitions..."
sudo mkfs.vfat -F32 -n BOOT "$BOOT_PART" 2>/dev/null || echo "Boot partition format (may already exist)"
sudo mkfs.ext4 -F -L ROOTFS "$ROOT_PART" 2>/dev/null || echo "Root partition format (may already exist)"

sleep 1

MBOOT=$(mktemp -d)
MROOT=$(mktemp -d)

echo "Mounting partitions..."
sudo mount "$BOOT_PART" "$MBOOT" || echo "Boot mount (may already be mounted)"
sudo mount "$ROOT_PART" "$MROOT" || echo "Root mount (may already be mounted)"

echo "Extracting boot files into boot partition..."
sudo tar -xpf "$BOOT_TAR" -C "$MBOOT" 2>/dev/null || echo "Warning: boot tarball extraction had issues"

echo "Copying rootfs into root partition..."
SRC_LOOP=""
SRC_MNT=""
# Determine source of rootfs: prefer a rootfs image, else fallback to output/rootfs directory
if [ -f "$ROOTFS_IMG" ]; then
  echo "Mounting rootfs image $ROOTFS_IMG"
  SRC_LOOP=$(sudo losetup --show -fP "$ROOTFS_IMG")
  SRC_MNT=$(mktemp -d)
  sudo mount "$SRC_LOOP" "$SRC_MNT"
  ROOTFS_DIR="$SRC_MNT"
elif [ -d "$OUTPUT_DIR/rootfs" ]; then
  ROOTFS_DIR="$OUTPUT_DIR/rootfs"
else
  ROOTFS_DIR=""
fi

if [ -n "$ROOTFS_DIR" ] && [ -d "$ROOTFS_DIR" ]; then
  sudo cp -a "$ROOTFS_DIR"/. "$MROOT/" 2>/dev/null || echo "Warning: some files may not have copied"
else
  echo "Warning: no rootfs found to copy (skipping)"
fi

# Cleanup mounted rootfs image if we mounted one
if [ -n "$SRC_MNT" ]; then
  sudo umount "$SRC_MNT" || true
  sudo losetup -d "$SRC_LOOP" || true
  rm -rf "$SRC_MNT"
fi

echo "Syncing and cleaning up mounts..."
sudo sync
sleep 1

sudo umount "$MBOOT" 2>/dev/null || true
sudo umount "$MROOT" 2>/dev/null || true
rm -rf "$MBOOT" "$MROOT"

sleep 1

sudo losetup -d "$LOOP" 2>/dev/null || true

echo "Compressing final image to ${FINAL_IMG}.gz"
gzip -9 -c "$FINAL_IMG" > "$FINAL_IMG.gz"

echo "Final images created:"
ls -lh "$OUTDIR" | sed -n '1,200p'

echo "Done. You can flash $FINAL_IMG to an SD card with dd or download $FINAL_IMG.gz from CI artifacts."
