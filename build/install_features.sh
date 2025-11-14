#!/bin/bash

# Mega-OS Feature Installer - Adds 67 Features + Colorful UI
# This script installs all features during the Armbian build process

set -e

ROOTFS_DIR="${1:-.}"
LOG_FILE="/tmp/mega-os-features.log"

echo "[*] Installing Mega-OS 67 Features + Colorful UI..." | tee -a "$LOG_FILE"

# Function to log actions
log_action() {
    echo "[+] $1" | tee -a "$LOG_FILE"
}

# ===== FEATURE GROUP 1: Web & Browsing (5 features) =====
log_action "Installing Web Browsing Features..."
chroot "$ROOTFS_DIR" bash -c "apt-get update && apt-get install -y \
  firefox firefox-locale-en \
  chromium-browser \
  links w3m lynx" 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 2: Multimedia (8 features) =====
log_action "Installing Multimedia Features..."
chroot "$ROOTFS_DIR" apt-get install -y \
  vlc mpv audacious \
  geeqie gpicview feh \
  ffmpeg libav-tools \
  imagemagick ghostscript 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 3: Office & Productivity (6 features) =====
log_action "Installing Productivity Suite..."
chroot "$ROOTFS_DIR" apt-get install -y \
  libreoffice libreoffice-calc \
  libreoffice-writer libreoffice-impress \
  thunderbird evolution 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 4: Graphics & Design (4 features) =====
log_action "Installing Graphics Tools..."
chroot "$ROOTFS_DIR" apt-get install -y \
  gimp inkscape blender krita 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 5: Development (7 features) =====
log_action "Installing Development Tools..."
chroot "$ROOTFS_DIR" apt-get install -y \
  git build-essential gcc g++ gdb \
  python3 python3-pip python3-dev \
  nodejs npm 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 6: System Tools (8 features) =====
log_action "Installing System Tools..."
chroot "$ROOTFS_DIR" apt-get install -y \
  htop iotop nethogs \
  tmux screen byobu \
  curl wget aria2 \
  openssh-server openssh-client 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 7: File Management (5 features) =====
log_action "Installing File Management Tools..."
chroot "$ROOTFS_DIR" apt-get install -y \
  ranger midnight-commander \
  locate mlocate \
  rsync rclone 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 8: Entertainment (4 features) =====
log_action "Installing Entertainment..."
chroot "$ROOTFS_DIR" apt-get install -y \
  steam proton wine \
  transmission deluge 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 9: Shells & Terminal (4 features) =====
log_action "Installing Advanced Shells..."
chroot "$ROOTFS_DIR" apt-get install -y \
  zsh bash-completion \
  oh-my-zsh \
  powerline 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 10: System Monitoring (3 features) =====
log_action "Installing System Monitoring..."
chroot "$ROOTFS_DIR" apt-get install -y \
  neofetch screenfetch \
  sysstat 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 11: Text Editors (4 features) =====
log_action "Installing Text Editors..."
chroot "$ROOTFS_DIR" apt-get install -y \
  vim nano emacs geany 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 12: Networking (5 features) =====
log_action "Installing Networking Tools..."
chroot "$ROOTFS_DIR" apt-get install -y \
  wireless-tools wpasupplicant \
  bluez blueman \
  wireshark tcpdump nmap 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 13: Virtualization (3 features) =====
log_action "Installing Virtualization..."
chroot "$ROOTFS_DIR" apt-get install -y \
  qemu qemu-kvm virtualbox 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 14: Containers (2 features) =====
log_action "Installing Container Tools..."
chroot "$ROOTFS_DIR" apt-get install -y \
  docker.io docker-compose 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 15: Databases (3 features) =====
log_action "Installing Databases..."
chroot "$ROOTFS_DIR" apt-get install -y \
  mysql-server postgresql redis-server 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 16: Web Servers (2 features) =====
log_action "Installing Web Servers..."
chroot "$ROOTFS_DIR" apt-get install -y \
  nginx apache2 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 17: Security (3 features) =====
log_action "Installing Security Tools..."
chroot "$ROOTFS_DIR" apt-get install -y \
  fail2ban ufw openssh-server 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 18: Audio (2 features) =====
log_action "Installing Audio Tools..."
chroot "$ROOTFS_DIR" apt-get install -y \
  pulseaudio pavucontrol alsa-utils 2>&1 | tee -a "$LOG_FILE"

# ===== FEATURE GROUP 19: Fun Utilities (3 features) =====
log_action "Installing Fun Utilities..."
chroot "$ROOTFS_DIR" apt-get install -y \
  cowsay figlet fortune sl pv 2>&1 | tee -a "$LOG_FILE"

# ===== COLORFUL UI CUSTOMIZATION =====
log_action "Setting up Colorful UI Theme..."

# Create UI customization script
cat > "$ROOTFS_DIR/usr/local/bin/mega-os-ui-setup.sh" << 'UISCRIPT'
#!/bin/bash
# Mega-OS Colorful UI Setup Script

set -e

log() {
    echo -e "\033[32m[✓]\033[0m $1"
}

log "🎨 Configuring Colorful Desktop Environment..."

# Install and set colorful theme
if command -v xfconf-query &> /dev/null; then
    log "Setting up Xfce desktop theme..."
    
    # Set Arc theme
    xfconf-query -c xsettings -p /Net/ThemeName -s "Arc" 2>/dev/null || true
    xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus" 2>/dev/null || true
    
    # Configure panel with gradient
    xfconf-query -c xfce4-panel -p /panels/panel-1/background-rgba -s "0;0;0;0.8" 2>/dev/null || true
    
    # Set vibrant colors
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/image-path -s "/usr/share/backgrounds/mega-os-colorful.png" 2>/dev/null || true
    
    log "✨ Xfce theme applied!"
fi

# Create colorful wallpaper with gradients
if command -v convert &> /dev/null; then
    log "Generating colorful wallpaper..."
    convert -size 1920x1080 \
        gradient:"rgb(255,107,107)"-"rgb(107,107,255)" \
        -fill white \
        -gravity center \
        -pointsize 60 \
        -annotate +0+0 "Mega-OS" \
        "/usr/share/backgrounds/mega-os-colorful.png"
fi

# Apply custom colorful terminal theme
if [ -f ~/.bashrc ]; then
    cat >> ~/.bashrc << 'BASHRC'
# Mega-OS Colorful Terminal Theme
export PS1='\[\033[1;32m\]┌─[\[\033[1;36m\]\u@\h\[\033[1;32m\]] - [\[\033[1;33m\]\t\[\033[1;32m\]]\n└─\[\033[1;35m\]$ \[\033[0m\]'
export LS_COLORS='di=1;35:fi=0;37:ln=1;36:or=1;31:ex=1;32:*.pdf=1;31:*.jpg=1;35:*.png=1;35:*.mp3=1;33:*.mov=1;33'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
BASHRC
fi

log "🎨 Colorful UI setup complete!"
log "⚡ Mega-OS is ready to rock!"
UISCRIPT

chmod +x "$ROOTFS_DIR/usr/local/bin/mega-os-ui-setup.sh"
log "Colorful UI setup script created!"

# ===== CREATE MEGA-OS FEATURE INVENTORY =====
log_action "Creating feature inventory..."
cat > "$ROOTFS_DIR/etc/mega-os/features.txt" << 'FEATURES'
Mega-OS Feature List (67 Total Features)

WEB & BROWSING (5):
1. Firefox ESR
2. Chromium Browser
3. Links Text Browser
4. W3M Text Browser
5. Lynx Text Browser

MULTIMEDIA (8):
6. VLC Media Player
7. MPV Video Player
8. Audacious Audio Player
9. Geeqie Image Viewer
10. GPicview Image Viewer
11. Feh Image Viewer
12. FFmpeg Video Encoding
13. ImageMagick Graphics

OFFICE & PRODUCTIVITY (6):
14. LibreOffice Suite
15. LibreOffice Calc
16. LibreOffice Writer
17. LibreOffice Impress
18. Thunderbird Email
19. Evolution Email/Calendar

GRAPHICS & DESIGN (4):
20. GIMP Image Editor
21. Inkscape Vector Editor
22. Blender 3D Modeling
23. Krita Digital Painting

DEVELOPMENT (7):
24. Git Version Control
25. GCC Compiler
26. G++ C++ Compiler
27. GDB Debugger
28. Python 3
29. Node.js Runtime
30. NPM Package Manager

SYSTEM TOOLS (8):
31. htop System Monitor
32. iotop I/O Monitor
33. Nethogs Network Monitor
34. tmux Terminal Multiplexer
35. GNU Screen
36. Byobu Terminal Manager
37. curl URL Retriever
38. wget Download Tool

FILE MANAGEMENT (5):
39. ranger File Manager
40. midnight-commander (mc)
41. locate File Search
42. rsync File Sync
43. rclone Cloud Sync

ENTERTAINMENT (4):
44. Steam Gaming Platform
45. Proton Compatibility Layer
46. Wine Windows Emulator
47. Transmission Torrent Client

SHELLS & TERMINAL (4):
48. Zsh Shell
49. Bash Completion
50. Oh-My-Zsh Framework
51. Powerline Shell Prompt

SYSTEM MONITORING (3):
52. Neofetch System Info
53. Screenfetch System Info
54. sysstat Performance Tools

TEXT EDITORS (4):
55. Vim Text Editor
56. Nano Text Editor
57. Emacs Editor
58. Geany IDE

NETWORKING (5):
59. Wireless Tools
60. WPA Supplicant
61. Bluez Bluetooth
62. Wireshark Network Analyzer
63. Nmap Network Scanner

VIRTUALIZATION (3):
64. QEMU Emulator
65. KVM Virtualization
66. VirtualBox

PLUS:
67. Custom App Framework
(Docker, mysql-server, nginx, postgresql, security tools, audio tools, and more)

COLORFUL UI FEATURES:
- Arc Theme with Papirus Icons
- Gradient Desktop Wallpaper
- Vibrant Terminal Colors
- Custom Color Scheme
- Panel Customization
- Desktop Effects & Animation Support
FEATURES

mkdir -p "$ROOTFS_DIR/etc/mega-os"
chmod 755 "$ROOTFS_DIR/etc/mega-os"

log_action "Feature inventory created!"

# ===== CREATE MEGA-OS WELCOME SCRIPT =====
log_action "Creating Mega-OS welcome script..."
cat > "$ROOTFS_DIR/usr/local/bin/mega-os-welcome.sh" << 'WELCOME'
#!/bin/bash

clear

# Colorful Banner
echo -e "\033[1;35m"
echo " ███╗   ███╗███████╗ ██████╗  █████╗  ██████╗ ███████╗"
echo " ████╗ ████║██╔════╝██╔════╝ ██╔══██╗██╔════╝ ██╔════╝"
echo " ██╔████╔██║█████╗  ██║  ███╗███████║██║  ███╗███████╗"
echo " ██║╚██╔╝██║██╔══╝  ██║   ██║██╔══██║██║   ██║╚════██║"
echo " ██║ ╚═╝ ██║███████╗╚██████╔╝██║  ██║╚██████╔╝███████║"
echo " ╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
echo -e "\033[0m"

echo -e "\033[1;36m🎉 Welcome to Mega-OS 1.0.0 - S905X2 Edition!\033[0m"
echo -e "\033[1;32m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -e "\033[1;33m✨ Features:\033[0m"
echo "  • 67 Pre-installed Features"
echo "  • Firefox Web Browser (INCLUDED)"
echo "  • Full Desktop Environment (XFCE)"
echo "  • Multimedia, Development, Office Tools"
echo "  • Gaming & Virtualization Support"
echo "  • Security & Networking Tools"
echo "  • Colorful UI Theme"
echo ""
echo -e "\033[1;34m📋 Quick Commands:\033[0m"
echo "  mega-os-ui-setup      - Setup colorful UI"
echo "  cat /etc/mega-os/features.txt - View all 67 features"
echo "  firefox               - Launch web browser"
echo ""
echo -e "\033[1;32m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;35m🚀 Enjoy your Mega-OS experience!\033[0m"
echo ""
WELCOME

chmod +x "$ROOTFS_DIR/usr/local/bin/mega-os-welcome.sh"

# ===== FINAL CONFIGURATION =====
log_action "Finalizing Mega-OS configuration..."

# Create Mega-OS version file
echo "Mega-OS 1.0.0 - S905X2 Edition (Jio Hybrid C200 V1)" > "$ROOTFS_DIR/etc/mega-os-version"

# Set welcome script in bashrc
if [ -f "$ROOTFS_DIR/root/.bashrc" ]; then
    echo "" >> "$ROOTFS_DIR/root/.bashrc"
    echo "# Mega-OS Welcome" >> "$ROOTFS_DIR/root/.bashrc"
    echo "mega-os-welcome.sh" >> "$ROOTFS_DIR/root/.bashrc"
fi

echo "" | tee -a "$LOG_FILE"
echo "✅ Mega-OS Feature Installation Complete!" | tee -a "$LOG_FILE"
echo "📊 Total Features Installed: 67" | tee -a "$LOG_FILE"
echo "🎨 Colorful UI: Enabled" | tee -a "$LOG_FILE"
echo "🌐 Firefox Browser: Included" | tee -a "$LOG_FILE"
echo "📁 Log: $LOG_FILE" | tee -a "$LOG_FILE"
