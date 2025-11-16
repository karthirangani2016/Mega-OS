#!/usr/bin/env bash
set -euo pipefail

# make_rootfs_image.sh
# Creates an arm64 rootfs using debootstrap and packages it into an ext4 image.
# Intended to run on a Linux host (CI runner) with sudo available.

OUTDIR="output"
WORKDIR="build/rootfs-work"
ROOTFS_DIR="$WORKDIR/rootfs"
IMAGE_NAME="mega-os-rootfs.img"
IMAGE_SIZE=${IMAGE_SIZE:-2G}

mkdir -p "$OUTDIR" "$WORKDIR"

echo "Installing required packages (debootstrap, qemu-user-static, rsync)..."
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends debootstrap qemu-user-static binfmt-support rsync sudo

echo "Creating base Debian/Ubuntu jammy arm64 rootfs via debootstrap (may take several minutes)..."
sudo debootstrap --arch=arm64 --variant=minbase jammy "$ROOTFS_DIR" http://ports.ubuntu.com/

echo "Copying qemu-aarch64-static for chroot emulation..."
sudo cp /usr/bin/qemu-aarch64-static "$ROOTFS_DIR/usr/bin/" || true

echo "Chroot: configuring basic packages inside rootfs..."
sudo mount --bind /dev "$ROOTFS_DIR/dev"
sudo mount --bind /proc "$ROOTFS_DIR/proc"
sudo mount --bind /sys "$ROOTFS_DIR/sys"
sudo chroot "$ROOTFS_DIR" /usr/bin/qemu-aarch64-static /bin/bash -lc "export DEBIAN_FRONTEND=noninteractive; apt-get update; apt-get install -y --no-install-recommends ca-certificates locales dialog net-tools iproute2 iputils-ping; apt-get clean"

echo "Cleaning up mounts..."
sudo umount "$ROOTFS_DIR/dev" || true
sudo umount "$ROOTFS_DIR/proc" || true
sudo umount "$ROOTFS_DIR/sys" || true

echo "Creating ext4 image ($IMAGE_SIZE) and populating with rootfs..."
IMAGE_PATH="$OUTDIR/$IMAGE_NAME"
sudo fallocate -l "$IMAGE_SIZE" "$IMAGE_PATH"
sudo mkfs.ext4 -F "$IMAGE_PATH"

MNT=$(mktemp -d)
sudo mount -o loop "$IMAGE_PATH" "$MNT"
sudo rsync -aH --exclude=/dev --exclude=/proc --exclude=/sys --exclude=/tmp "$ROOTFS_DIR/" "$MNT/"
sudo umount "$MNT"
rmdir "$MNT"

echo "Compressing image to $IMAGE_PATH.gz"
gzip -9 -c "$IMAGE_PATH" > "$IMAGE_PATH.gz"

echo "Rootfs image and compressed image created in $OUTDIR:"
ls -lh "$OUTDIR" | sed -n '1,200p'

echo "Done. You can download output/$IMAGE_NAME.gz from CI artifacts or copy output/$IMAGE_NAME to your flashing host."
