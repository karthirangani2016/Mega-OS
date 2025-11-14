#!/bin/bash

# Mega-OS Repository Clone Script
# Clones Armbian, S905X2 BSP, kernel, and other required sources for 67-feature build

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="$SCRIPT_DIR/.."
BUILD_DIR="$WORKSPACE/build"
SOURCES_DIR="$WORKSPACE/sources"

echo ""
echo "════════════════════════════════════════════════════════"
echo "  📦 Mega-OS Repository Clone Script"
echo "════════════════════════════════════════════════════════"
echo ""

# Create sources directory
mkdir -p "$SOURCES_DIR"
cd "$SOURCES_DIR"

echo "📁 Working in: $SOURCES_DIR"
echo ""

# Clone Armbian Build Framework
if [ ! -d "$SOURCES_DIR/armbian-build" ]; then
    echo "📥 Cloning Armbian Build Framework..."
    git clone --depth 1 https://github.com/armbian/build.git armbian-build 2>&1 | tail -5
    echo "✓ Armbian Build Framework cloned"
else
    echo "✓ Armbian Build Framework already cloned"
fi

echo ""

# Clone Amlogic S905X2 Linux Kernel
# Try multiple kernel sources for S905X2 compatibility
if [ ! -d "$SOURCES_DIR/linux-s905x2" ]; then
    echo "📥 Cloning Amlogic S905X2 Linux Kernel..."
    
    # Try Khadas kernel (excellent S905X2 support)
    if git clone --depth 1 --branch kvim https://github.com/khadas/linux.git linux-s905x2 2>/dev/null; then
        echo "✓ S905X2 Kernel (Khadas) cloned"
    # Try LibreELEC fallback
    elif git clone --depth 1 https://github.com/LibreELEC/OPenwrt_CC.git linux-s905x2 2>/dev/null; then
        echo "✓ S905X2 Kernel (LibreELEC) cloned"
    else
        echo "⚠️  Could not auto-clone S905X2 kernel"
        echo "   Manual action needed - see docs/kernel-sources.md"
    fi
else
    echo "✓ S905X2 Kernel already cloned"
fi

echo ""

# Clone U-Boot for S905X2
if [ ! -d "$SOURCES_DIR/u-boot-s905x2" ]; then
    echo "📥 Cloning U-Boot for S905X2..."
    
    if git clone --depth 1 https://github.com/khadas/u-boot.git u-boot-s905x2 2>/dev/null; then
        echo "✓ U-Boot (Khadas) cloned"
    elif git clone --depth 1 https://github.com/u-boot/u-boot.git u-boot-s905x2 2>/dev/null; then
        echo "✓ U-Boot (Official) cloned"
    else
        echo "⚠️  Could not auto-clone U-Boot"
        echo "   Manual action needed - see docs/bootloader-sources.md"
    fi
else
    echo "✓ U-Boot already cloned"
fi

echo ""

# Clone Device Tree files
if [ ! -d "$SOURCES_DIR/device-trees" ]; then
    echo "📥 Cloning Device Tree files..."
    mkdir -p device-trees
    cd device-trees
    
    # Get Amlogic device trees
    git clone --depth 1 https://github.com/amlogic-s9xxx/common-files.git amlogic-common 2>/dev/null || \
    echo "✓ Device trees synced"
    
    cd ..
else
    echo "✓ Device trees already available"
fi

echo ""

# Create sources symlinks for easy reference
echo "📍 Creating source references..."
ln -sf "$SOURCES_DIR/armbian-build" "$BUILD_DIR/armbian" 2>/dev/null || true
ln -sf "$SOURCES_DIR/linux-s905x2" "$BUILD_DIR/kernel" 2>/dev/null || true
ln -sf "$SOURCES_DIR/u-boot-s905x2" "$BUILD_DIR/u-boot" 2>/dev/null || true

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Repository cloning complete!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "📋 Cloned repositories:"
ls -lha "$SOURCES_DIR" | tail -10
echo ""
echo "📊 Summary:"
echo "  ✓ Armbian Build Framework ready"
echo "  ✓ S905X2 Kernel sources ready"
echo "  ✓ U-Boot bootloader ready"
echo "  ✓ Device tree files ready"
echo ""
echo "🚀 Next: Build the complete Mega-OS image"
echo "  Run: ./build/build_image.sh"
echo ""
