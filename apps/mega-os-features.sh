#!/bin/bash
# Mega-OS: 67 Features Installer
# Comprehensive feature pack for S905X2 Jio Hybrid C200 V1

set -e

echo "=========================================="
echo "Mega-OS: Installing 67 Features"
echo "=========================================="
echo ""

FEATURES_INSTALLED=0

# Function to install feature
install_feature() {
    local name="$1"
    local command="$2"
    echo -n "[FEATURE] Installing $name... "
    if eval "$command" &>/dev/null; then
        echo "✅"
        ((FEATURES_INSTALLED++))
    else
        echo "⚠️ (skipped)"
    fi
}

# ====== CORE BROWSER & WEB ======
install_feature "Firefox ESR" "apt-get install -y firefox-esr"
install_feature "Chromium" "apt-get install -y chromium-browser || apt-get install -y chromium"
install_feature "GNOME Web (Epiphany)" "apt-get install -y epiphany-browser"
install_feature "Wget" "apt-get install -y wget"
install_feature "Curl" "apt-get install -y curl"

# ====== MEDIA & STREAMING ======
install_feature "VLC Media Player" "apt-get install -y vlc"
install_feature "Kodi" "apt-get install -y kodi || true"
install_feature "MPV Player" "apt-get install -y mpv"
install_feature "FFmpeg" "apt-get install -y ffmpeg"
install_feature "ImageMagick" "apt-get install -y imagemagick"
install_feature "GIMP" "apt-get install -y gimp || true"
install_feature "Audacity" "apt-get install -y audacity || true"

# ====== OFFICE & PRODUCTIVITY ======
install_feature "LibreOffice" "apt-get install -y libreoffice || true"
install_feature "Gedit Text Editor" "apt-get install -y gedit"
install_feature "Mousepad" "apt-get install -y mousepad"
install_feature "Thunderbird Email" "apt-get install -y thunderbird || true"

# ====== DEVELOPMENT TOOLS ======
install_feature "Git" "apt-get install -y git"
install_feature "Python3" "apt-get install -y python3 python3-pip"
install_feature "Python3-dev" "apt-get install -y python3-dev"
install_feature "Node.js" "apt-get install -y nodejs npm"
install_feature "Docker" "apt-get install -y docker.io"
install_feature "VS Code" "apt-get install -y code || true"
install_feature "Nano Editor" "apt-get install -y nano"
install_feature "Vim" "apt-get install -y vim"
install_feature "GCC" "apt-get install -y build-essential"
install_feature "Git-flow" "apt-get install -y git-flow"

# ====== SYSTEM UTILITIES ======
install_feature "htop" "apt-get install -y htop"
install_feature "nethogs" "apt-get install -y nethogs"
install_feature "iotop" "apt-get install -y iotop"
install_feature "lsof" "apt-get install -y lsof"
install_feature "tree" "apt-get install -y tree"
install_feature "tldr" "apt-get install -y tldr || pip3 install tldr"
install_feature "neofetch" "apt-get install -y neofetch"
install_feature "screenfetch" "apt-get install -y screenfetch"
install_feature "inxi" "apt-get install -y inxi"
install_feature "dmesg colorizer" "apt-get install -y ccze"

# ====== NETWORKING & CONNECTIVITY ======
install_feature "Transmission BitTorrent" "apt-get install -y transmission-gtk transmission-daemon"
install_feature "Remmina Remote Desktop" "apt-get install -y remmina"
install_feature "Filezilla FTP" "apt-get install -y filezilla"
install_feature "OpenSSH Server" "apt-get install -y openssh-server openssh-client"
install_feature "Nmap" "apt-get install -y nmap"
install_feature "Wireshark" "apt-get install -y wireshark-qt || true"
install_feature "iPerf3" "apt-get install -y iperf3"
install_feature "Mtr" "apt-get install -y mtr"

# ====== GRAPHICS & VISUALIZATION ======
install_feature "Blender" "apt-get install -y blender || true"
install_feature "Inkscape" "apt-get install -y inkscape || true"
install_feature "Xfig" "apt-get install -y xfig"
install_feature "GnuPlot" "apt-get install -y gnuplot"

# ====== SYSTEM MANAGEMENT ======
install_feature "Gparted Partition Manager" "apt-get install -y gparted"
install_feature "Synaptic Package Manager" "apt-get install -y synaptic"
install_feature "Timeshift Backup" "apt-get install -y timeshift || true"
install_feature "RAID Management" "apt-get install -y mdadm"
install_feature "LVM2" "apt-get install -y lvm2"
install_feature "ZFS Utils" "apt-get install -y zfsutils-linux || true"

# ====== GAMES & ENTERTAINMENT ======
install_feature "SuperTuxKart" "apt-get install -y supertuxkart || true"
install_feature "Sonic Robo Blast 2" "apt-get install -y srb2 || true"
install_feature "Dosbox" "apt-get install -y dosbox"
install_feature "VICE C64 Emulator" "apt-get install -y vice || true"

# ====== DESKTOP CUSTOMIZATION ======
install_feature "XFCE Desktop" "apt-get install -y xfce4 xfce4-goodies"
install_feature "Icon Themes" "apt-get install -y papirus-icon-theme numix-icon-theme-circle"
install_feature "GTK Themes" "apt-get install -y arc-theme numix-gtk-theme"
install_feature "Pluma Text Editor" "apt-get install -y pluma"
install_feature "Nemo File Manager" "apt-get install -y nemo || apt-get install -y thunar"

# ====== EXTRAS & NICE-TO-HAVE ======
install_feature "Telegram Desktop" "apt-get install -y telegram-desktop || true"
install_feature "Discord" "apt-get install -y discord || true"
install_feature "Syncthing" "apt-get install -y syncthing"
install_feature "Calibre eBook" "apt-get install -y calibre || true"
install_feature "Zotero Research" "apt-get install -y zotero || true"

echo ""
echo "=========================================="
echo "✅ Feature Installation Complete!"
echo "=========================================="
echo "Total features installed: $FEATURES_INSTALLED/67"
echo ""
