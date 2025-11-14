# Build README - Mega-OS for S905X2

## Overview

This directory contains scripts and configurations to build Mega-OS — a custom Armbian-based distribution with Firefox browser integration for Amlogic S905X2 devices.

## Quick Build

### Prerequisites

- Ubuntu 20.04 LTS or newer (or use Docker)
- 50+ GB free disk space
- 8+ GB RAM
- Stable internet connection

### Step-by-step

```bash
# 1. Set up host environment
chmod +x *.sh
./setup_host.sh

# 2. Clone required repositories
./clone_repos.sh

# 3. Build Mega-OS image (30-60 min)
./build_image.sh

# 4. Find output
ls -lh ../output/mega-os-s905x2.img
```

## Docker Build (Recommended)

To avoid installing 50+ build dependencies on your host:

```bash
# From Mega-OS root directory
docker build -t mega-os-build .
docker run --rm -it \
  -v "$PWD":/workspace \
  -w /workspace \
  mega-os-build /bin/bash

# Inside container:
cd /workspace
./build/setup_host.sh
./build/clone_repos.sh
./build/build_image.sh
```

## File Structure

```
build/
├── setup_host.sh           # Install Ubuntu/Debian build tools
├── clone_repos.sh          # Clone Armbian, kernel, U-Boot
├── build_image.sh          # Main build orchestration
├── config/
│   ├── s905x2.config        # S905X2-specific parameters
│   └── packages.txt         # Additional packages (Firefox, etc.)
├── logs/                   # Build output logs
└── README.md               # This file
```

## Customization

### Add Firefox or other browsers

Edit `build_image.sh` Phase 2 and modify the `packages-override.txt` section:

```bash
cat > "$BUILD_DIR/packages-override.txt" << 'PKGEOF'
firefox
firefox-locale-en
chromium-browser  # Alternative
PKGEOF
```

### Change desktop environment

Options: `xfce`, `gnome`, `kde`, `lxde`, `cinnamon`

In `s905x2.config`:
```bash
DESKTOP_ENVIRONMENT="xfce"  # Change this
```

### Add custom apps

Place scripts in `../apps/*.sh`. They will be sourced during rootfs build.

Example `../apps/my-app.sh`:
```bash
#!/bin/bash
apt-get install -y my-package
systemctl enable my-service
```

## Build Phases

### Phase 1: Verify Prerequisites
- Checks Armbian sources exist
- Validates toolchain installation

### Phase 2: Compile Armbian Image
- Builds Linux kernel for S905X2
- Compiles device tree blobs
- Creates U-Boot bootloader
- Builds Debian rootfs
- Installs Firefox and desktop

### Phase 3: Integrate Custom Apps
- Runs any scripts in `../apps/`
- Configures system services

### Phase 4: Create Final Image
- Packages rootfs into bootable image
- Generates image information file

## Output

After successful build:

```
output/
├── mega-os-s905x2.img      # Bootable image (~1.5 GB)
├── mega-os-s905x2.tar.gz   # Rootfs archive
└── image-info.txt          # Metadata
```

## Troubleshooting

### Build fails during kernel compilation

```bash
# Check the build log
tail -100 logs/build.log

# Common issue: missing cross-compiler
./setup_host.sh && ./build_image.sh
```

### Insufficient disk space

```bash
# Check available space
df -h

# Clean old builds
rm -rf sources/  # If re-running
```

### Network timeout during package download

```bash
# Re-run the build (Armbian caches partial downloads)
./build_image.sh
```

## Advanced: Manual Armbian Build

If you want full control over the Armbian build system:

```bash
cd sources/armbian-build/

# Run Armbian's interactive build
sudo ./compile.sh

# Configuration menu will appear:
# - Select: Generic build (default)
# - Board: Meson64 (S905X2)
# - Release: Jammy
# - Desktop: XFCE
# - Build desktop: Yes
```

## References

- [Armbian Build Documentation](https://docs.armbian.com)
- [S905X2 Kernel Sources](https://github.com/khadas/linux)
- [Firefox for ARM](https://www.mozilla.org/firefox)
- [Jio Hybrid C200 V1 Specifications](https://www.jiofiberdevice.com)

## Performance Tips

- Use SSD for faster builds
- Allocate 8+ GB RAM for faster compilation
- Use Docker on slower machines (cgroup v2 helps)

---

**Build responsibly. Test thoroughly before deploying to production.** ✨
