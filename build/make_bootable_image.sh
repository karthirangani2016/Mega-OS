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
SECTOR_SIZE=512
BOOT_SECTORS=$((BOOT_SIZE_BYTES / SECTOR_SIZE))

# Use parted (more reliable than sfdisk)
sudo parted -s "$FINAL_IMG" mklabel msdos
sudo parted -s "$FINAL_IMG" mkpart primary fat32 2048s $((2048 + BOOT_SECTORS))s
sudo parted -s "$FINAL_IMG" mkpart primary ext4 $((2048 + BOOT_SECTORS))s 100%
sudo parted -s "$FINAL_IMG" set 1 boot on

echo "Setting up loop device for image..."
LOOP=$(sudo losetup --show -fP "$FINAL_IMG")
echo "Loop device: $LOOP"

BOOT_PART=${LOOP}p1
ROOT_PART=${LOOP}p2

echo "Formatting partitions..."
sudo mkfs.vfat -F32 -n BOOT "$BOOT_PART"
sudo mkfs.ext4 -F -L ROOTFS "$ROOT_PART"

MBOOT=$(mktemp -d)
MROOT=$(mktemp -d)
sudo mount "$BOOT_PART" "$MBOOT"
sudo mount "$ROOT_PART" "$MROOT"

echo "Extracting boot files into boot partition..."
sudo tar -xpf "$BOOT_TAR" -C "$MBOOT"

echo "Copying rootfs into root partition..."
# Mount the rootfs image and rsync its contents
SRC_LOOP=$(sudo losetup --show -fP "$ROOTFS_IMG")
SRC_PART=${SRC_LOOP}
SRC_MNT=$(mktemp -d)
sudo mount "$SRC_PART" "$SRC_MNT"
sudo rsync -aH --exclude=/dev --exclude=/proc --exclude=/sys --exclude=/tmp "$SRC_MNT/" "$MROOT/"
sudo umount "$SRC_MNT" || true
sudo losetup -d "$SRC_LOOP" || true
rm -rf "$SRC_MNT"

echo "Syncing and cleaning up mounts..."
sudo sync
sudo umount "$MBOOT" || true
sudo umount "$MROOT" || true
rm -rf "$MBOOT" "$MROOT"

sudo losetup -d "$LOOP" || true

echo "Compressing final image to ${FINAL_IMG}.gz"
gzip -9 -c "$FINAL_IMG" > "$FINAL_IMG.gz"

echo "Final images created:"
ls -lh "$OUTDIR" | sed -n '1,200p'

echo "Done. You can flash $FINAL_IMG to an SD card with dd or download $FINAL_IMG.gz from CI artifacts."
