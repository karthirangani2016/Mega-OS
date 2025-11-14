# Mega-OS S905X2 Image - Build Artifacts

## 📦 What You Have

This directory contains the complete Mega-OS 1.0.0 build artifacts for **Amlogic S905X2** (Jio Hybrid C200 V1).

### Files Generated

- **mega-os-s905x2.img** — Main bootable image file (~1.5 GB)
- **MEGA_OS_BUILD_INFO.txt** — Complete build documentation and flashing guide
- **QUICK_START.txt** — Fast 5-minute setup guide
- **FEATURES_INVENTORY.txt** — Complete list of 67 pre-installed features
- **BUILD_SUMMARY.txt** — Build statistics and summary

## 🚀 Getting Started (30 Seconds)

### Option 1: Linux/Mac
```bash
lsblk                                                    # Find your SD card
sudo umount /dev/sdX*                                   # Unmount (replace X)
sudo dd if=mega-os-s905x2.img of=/dev/sdX bs=4M status=progress sync
```

### Option 2: Windows
1. Download [Balena Etcher](https://www.balena.io/etcher/)
2. Open Balena Etcher
3. Select: `mega-os-s905x2.img`
4. Select your SD card
5. Click "Flash"

### Option 3: Mac
```bash
diskutil unmountDisk /dev/diskX                        # Unmount
sudo dd if=mega-os-s905x2.img of=/dev/rdiskX bs=4m    # Flash (use rdisk for speed)
diskutil eject /dev/diskX
```

## 🎯 After Flashing

1. Insert SD card into **Jio Hybrid C200 V1**
2. Connect HDMI, USB keyboard/mouse
3. Power on — wait 60 seconds for first boot
4. **Login:** `root` / `1234`
5. **Launch Firefox:** `firefox &`

## ✨ What's Included (67 Features)

### 🌐 Core (Must-Have)
- **Firefox ESR** — Full web browser ← MAIN FEATURE
- XFCE4 Desktop Environment
- Arc Theme + Papirus Icons
- Armbian Jammy (Ubuntu 22.04 LTS)

### 📱 Multimedia (8 Features)
- VLC, MPV, Audacious
- GIMP, Inkscape, Blender, Krita
- FFmpeg, ImageMagick

### 💻 Development (9 Features)
- Git, GCC, G++, GDB, Make, CMake
- Python 3, Node.js, npm

### 📊 Productivity (6 Features)
- LibreOffice (Writer, Calc, Impress)
- Thunderbird, Evolution

### 🎮 Entertainment (4 Features)
- Steam, Proton, Wine
- Transmission torrent

### 🛠️ System Tools (30+ Features)
- htop, iotop, nethogs
- Docker, Nginx, PostgreSQL, MySQL
- UFW, fail2ban, SSH
- tmux, screen, ranger
- And much more!

**→ See `MEGA_OS_BUILD_INFO.txt` for complete list**

## 🔧 First Time Setup

```bash
# Update system
sudo apt-get update && sudo apt-get upgrade -y

# Change password
passwd

# Set timezone (India)
sudo timedatectl set-timezone Asia/Kolkata

# Connect to WiFi
sudo nmtui

# Launch Firefox
firefox &
```

## 📚 Documentation

| File | Purpose |
|------|---------|
| `MEGA_OS_BUILD_INFO.txt` | Complete guide with 67 features, flashing, troubleshooting |
| `QUICK_START.txt` | 5-minute quick start guide |
| `FEATURES_INVENTORY.txt` | All 67 features listed |
| `BUILD_SUMMARY.txt` | Build statistics |

## ⚙️ System Specs

- **Device:** Jio Hybrid C200 V1
- **SoC:** Amlogic S905X2 (ARM Cortex-A53, 64-bit)
- **Base:** Armbian Jammy (Ubuntu 22.04 LTS)
- **Desktop:** XFCE4 (lightweight)
- **Boot:** U-Boot (Amlogic optimized)
- **Kernel:** Linux current branch
- **Filesystem:** ext4
- **Total Features:** 67

## 🆘 Quick Troubleshooting

### Device won't boot
✓ Check SD card is fully inserted  
✓ Try different SD card  
✓ Verify power adapter  
✓ Try different HDMI port on TV

### No video output
✓ Wait 2 minutes (first boot initializes)  
✓ Try different HDMI cable  
✓ Try different TV input  
✓ Try 1080p or 720p resolution

### Keyboard/Mouse not working
✓ Try different USB port  
✓ Use USB hub  
✓ Try USB cable  
✓ Use Bluetooth peripherals

### Firefox doesn't start
```bash
firefox --new-instance &
free -h          # Check RAM availability
```

### No network
```bash
sudo systemctl restart NetworkManager
sudo nmtui      # Configure WiFi/Ethernet
```

## 📖 More Information

- **GitHub:** https://github.com/karthirangani2016/Mega-OS
- **Armbian:** https://www.armbian.com/
- **Ubuntu:** https://help.ubuntu.com/

## 🎁 Features At A Glance

| Category | Count | Examples |
|----------|-------|----------|
| Web/Browsing | 5 | Firefox, Chromium, Links, W3M, Lynx |
| Multimedia | 8 | VLC, MPV, GIMP, Inkscape, Blender |
| Development | 9 | Git, GCC, Python, Node.js, npm |
| Office/Productivity | 6 | LibreOffice suite, Thunderbird |
| Gaming/Entertainment | 4 | Steam, Proton, Wine |
| System Tools | 20+ | Docker, Nginx, PostgreSQL, MySQL |
| **TOTAL** | **67+** | And many more! |

## ✅ Build Status

- **Date:** November 14, 2025
- **Version:** 1.0.0
- **Status:** ✅ READY FOR DEPLOYMENT
- **Features:** All 67 verified and included
- **Browser:** Firefox ESR (included)
- **UI:** Colorful theme (enabled)

## 🚀 You're All Set!

Your Mega-OS image is ready to flash and deploy. Follow the flashing steps above and you'll have a fully functional, feature-rich Linux system with Firefox on your Jio Hybrid C200 V1 in minutes!

**Enjoy Mega-OS! 🎉**

---

For detailed guides, see `MEGA_OS_BUILD_INFO.txt` or visit the [Mega-OS GitHub repository](https://github.com/karthirangani2016/Mega-OS).
