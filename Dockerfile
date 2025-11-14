# Dockerfile for Mega-OS Build Environment
# Reproducible build environment for Mega-OS S905X2 (67 features + Firefox)

FROM ubuntu:22.04

LABEL maintainer="Mega-OS Team"
LABEL description="Mega-OS Build Environment - Armbian-based S905X2 with 67 features and Firefox"

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update and install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc g++ \
    make cmake \
    git curl wget \
    bc bison flex \
    device-tree-compiler \
    u-boot-tools \
    libssl-dev \
    libelf-dev \
    libfdt-dev \
    pigz pv \
    zip unzip xz-utils lz4 \
    ccache distcc \
    gcc-arm-linux-gnueabihf \
    gcc-aarch64-linux-gnu \
    g++-arm-linux-gnueabihf \
    g++-aarch64-linux-gnu \
    binutils-arm-linux-gnueabihf \
    binutils-aarch64-linux-gnu \
    crossbuild-essential-armhf \
    crossbuild-essential-arm64 \
    qemu-user-static \
    binfmt-support \
    dosfstools mtools \
    parted e2fsprogs \
    qemu-system-arm \
    debootstrap \
    systemd-container \
    docker.io \
    imagemagick \
    screen tmux htop tree \
    net-tools openssh-client \
    rsync jq vim-common \
    expect dialog \
    lsb-release \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create workspace
WORKDIR /workspace

# Copy build scripts
COPY build/ /workspace/build/
COPY apps/ /workspace/apps/ || true
COPY sources/ /workspace/sources/ 2>/dev/null || true

# Make scripts executable
RUN chmod +x /workspace/build/*.sh

# Create output directory
RUN mkdir -p /workspace/output /workspace/build/logs

# Add entry point script
RUN cat > /docker-entrypoint.sh << 'ENTRYPOINT'
#!/bin/bash
set -e

echo ""
echo "════════════════════════════════════════════════════════"
echo "  🐳 Mega-OS Build Docker Container"
echo "════════════════════════════════════════════════════════"
echo ""
echo "This container provides a reproducible build environment"
echo "for Mega-OS S905X2 (67 features + Firefox)"
echo ""
echo "Available commands:"
echo "  ./build/setup_host.sh      - Setup build environment"
echo "  ./build/clone_repos.sh     - Clone Armbian + sources"
echo "  ./build/build_image.sh     - Build Mega-OS image"
echo ""
echo "Quick start:"
echo "  ./build/clone_repos.sh && ./build/build_image.sh"
echo ""
echo "════════════════════════════════════════════════════════"
echo ""

# If command provided, execute it
if [ $# -gt 0 ]; then
    exec "$@"
else
    /bin/bash
fi
ENTRYPOINT

chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]

# Build labels
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.url="https://github.com/karthirangani2016/Mega-OS"
LABEL org.opencontainers.image.vendor="Mega-OS Team"
