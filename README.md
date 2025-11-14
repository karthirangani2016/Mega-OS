# Mega-OS

**Mega-OS** — a custom Armbian-based distribution for Amlogic S905X2 devices (target: Jio Hybrid C200 V1).

An excellent, web-enabled OS with integrated browser (Firefox), custom apps, and optimized performance.

## ✅ Core Features

- **Armbian base** — stable Debian-based userland
- **S905X2 kernel & DTB** — optimized for Jio Hybrid C200 V1
- **🌐 Firefox browser** — full web browsing capability (CORE REQUIREMENT)
- **Custom apps** — add your own tools and services
- **Bootable image** — SD card or eMMC flashing
- **Docker build** — reproducible build environment

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/karthirangani2016/Mega-OS.git
cd Mega-OS
```

### 2. Option A: Native build (Ubuntu/Debian host)

```bash
chmod +x build/*.sh
./build/setup_host.sh          # Install dependencies
./build/clone_repos.sh         # Clone Armbian, BSPs, kernel
./build/build_image.sh         # Build Mega-OS image (30-60 min)
```

### 3. Option B: Docker (reproducible, no host pollution)

```bash
docker build -t mega-os-build .
docker run --rm -it -v "$PWD":/workspace -w /workspace mega-os-build /bin/bash
# Inside container:
./build/build_image.sh
```

### 4. Flash to device

```bash
# List USB devices
lsblk

# Flash SD card (replace sdX with your device, e.g., sdb)
sudo dd if=output/mega-os-s905x2.img of=/dev/sdX bs=4M status=progress sync
```

## Build Output

- `output/mega-os-s905x2.img` — bootable image (~1.5 GB)
- `output/mega-os-s905x2.tar.gz` — rootfs archive
- `build/logs/` — build logs for debugging

## Device Info

- **Target Device:** Jio Hybrid C200 V1
- **SoC:** Amlogic S905X2
- **RAM:** 2 GB (typical)
- **Storage:** eMMC (internal) or SD card (boot)

## What's Included

1. **Armbian build system** — stable, well-maintained
2. **S905X2 BSP & kernel** — device tree + drivers
3. **🌐 Firefox ESR** — modern web browser (INCLUDED BY DEFAULT)
4. **Desktop environment** — lightweight DE (LXDE/Xfce) with X11
5. **System tools** — curl, wget, git, Python, Node.js, etc.
6. **Custom app framework** — `apps/` directory for your own tools

## Directory Structure

```
Mega-OS/
├── README.md                          # This file
├── build/
│   ├── setup_host.sh                  # Install build dependencies
│   ├── clone_repos.sh                 # Clone Armbian, BSP, kernel
│   ├── build_image.sh                 # Main build script
│   ├── config/
│   │   ├── armbian.config              # Armbian build config
│   │   └── s905x2.config               # S905X2-specific options
│   └── README.md                       # Detailed build instructions
├── apps/
│   ├── custom-app-1.sh                # Your custom apps here
│   └── README.md                       # App integration guide
├── docs/
│   ├── flash.md                       # Flashing instructions
│   ├── serial-debug.md                # Serial console setup
│   └── troubleshooting.md             # Common issues & fixes
├── Dockerfile                         # Reproducible build environment
└── output/                            # Build output (created at runtime)
```

## Adding Custom Apps

### 1. Create a script in `apps/my-app.sh`:

```bash
#!/bin/bash
# Install my custom app into the rootfs
echo "Installing My Custom App..."
apt-get install -y my-app-dependencies
```

## Debugging

### Serial console (TTL adapter required)

```bash
screen /dev/ttyUSB0 115200
```

### SSH into running device

```bash
ssh root@<device-ip>
```

## License

- **Mega-OS scaffolding:** MIT
- **Armbian:** GPL
- **Linux kernel:** GPL v2
- **Firefox:** Mozilla Public License

---

**Let's build an excellent, browser-enabled OS!** 🚀
