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

# Copy build scripts (main build directory)
COPY build/ /workspace/build/

# Copy apps directory if it exists
RUN mkdir -p /workspace/apps

# Make scripts executable
RUN chmod +x /workspace/build/*.sh || true

# Create output directory
RUN mkdir -p /workspace/output /workspace/build/logs

# Create a simple entrypoint script
RUN echo '#!/bin/bash' > /docker-entrypoint.sh && \
    echo 'set -e' >> /docker-entrypoint.sh && \
    echo 'echo "Mega-OS Build Container"' >> /docker-entrypoint.sh && \
    echo 'exec "$@"' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.url="https://github.com/karthirangani2016/Mega-OS"
LABEL org.opencontainers.image.vendor="Mega-OS Team"
