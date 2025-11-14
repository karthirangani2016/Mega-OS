#!/bin/bash

# Mega-OS Build Host Setup Script
# Prepares Ubuntu/Debian host for Armbian S905X2 builds with 67 features

set -e

echo ""
echo "════════════════════════════════════════════════════════"
echo "  🔧 Mega-OS Build Environment Setup"
echo "════════════════════════════════════════════════════════"
echo ""

# Check if running on Ubuntu/Debian
if ! command -v apt-get &> /dev/null; then
    echo "❌ ERROR: This script requires Ubuntu/Debian (apt-get not found)"
    exit 1
fi

# Detect Ubuntu/Debian version
DISTRO=$(lsb_release -si 2>/dev/null || echo "Unknown")
VERSION=$(lsb_release -sr 2>/dev/null || echo "Unknown")
echo "📦 Detected: $DISTRO $VERSION"
echo ""

# Check disk space
DISK_SPACE=$(df /workspace 2>/dev/null | awk 'NR==2 {print $4}')
echo "💾 Available disk space: $((DISK_SPACE / 1024 / 1024)) GB"
if [ "$DISK_SPACE" -lt $((20 * 1024 * 1024)) ]; then
    echo "⚠️  WARNING: At least 20GB recommended for build cache"
fi
echo ""

# Update package lists
echo "📥 Step 1/5: Updating package lists..."
apt-get update -qq

# Install essential build tools
echo "📥 Step 2/5: Installing essential build tools..."
apt-get install -y --no-install-recommends \
    build-essential gcc g++ make cmake \
    git curl wget bc bison flex \
    device-tree-compiler u-boot-tools \
    libssl-dev libelf-dev libfdt-dev \
    pigz pv zip unzip xz-utils lz4 \
    ccache distcc

# Install ARM cross-compilation toolchain
echo "📥 Step 3/5: Installing ARM cross-compilation toolchain..."
apt-get install -y --no-install-recommends \
    gcc-arm-linux-gnueabihf gcc-aarch64-linux-gnu \
    g++-arm-linux-gnueabihf g++-aarch64-linux-gnu \
    binutils-arm-linux-gnueabihf binutils-aarch64-linux-gnu \
    crossbuild-essential-armhf crossbuild-essential-arm64

# Install image and filesystem tools
echo "📥 Step 4/5: Installing image and filesystem tools..."
apt-get install -y --no-install-recommends \
    qemu-user-static binfmt-support \
    dosfstools mtools parted e2fsprogs \
    qemu-system-arm debootstrap systemd-container \
    docker.io imagemagick expect dialog

# Install development utilities
echo "📥 Step 5/5: Installing development utilities..."
apt-get install -y --no-install-recommends \
    vim-common screen tmux htop tree \
    net-tools openssh-client rsync jq

# Clean up
apt-get clean
apt-get autoremove -y

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Build environment setup complete!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "📋 Summary:"
echo "  ✓ Build essentials installed"
echo "  ✓ Cross-compilation toolchain ready"
echo "  ✓ Docker installed"
echo "  ✓ Qemu and device tools configured"
echo "  ✓ Development utilities installed"
echo ""
echo "🚀 Ready to build Mega-OS with 67 features!"
echo ""
echo "Next steps:"
echo "  1. Run: chmod +x ./build/*.sh"
echo "  2. Run: ./build/clone_repos.sh"
echo "  3. Run: ./build/build_image.sh"
echo ""
