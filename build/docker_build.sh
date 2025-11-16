#!/usr/bin/env bash
set -euo pipefail

# Docker helper to build Mega-OS inside a container and keep host clean.
# Usage: ./build/docker_build.sh [build-image-name]
# Example: ./build/docker_build.sh mega-os-build

IMAGE_NAME=${1:-mega-os-build}
WORKDIR=$(pwd)
CONTAINER_NAME=mega-os-build-run

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required but not installed. Please install Docker and re-run."
  exit 1
fi

echo "Building Docker image '${IMAGE_NAME}' from ./Dockerfile..."
docker build -t "${IMAGE_NAME}" .

echo "Running build inside container (workspace mounted at /workspace)."
echo "This will run: ./build/build_image.sh inside the container"

docker run --rm -it \
  --name "${CONTAINER_NAME}" \
  -v "${WORKDIR}:/workspace" \
  -w /workspace \
  --env "SUDO_UID=$(id -u)" \
  --env "SUDO_GID=$(id -g)" \
  "${IMAGE_NAME}" \
  /bin/bash -lc "chmod +x ./build/*.sh && ./build/build_image.sh"

echo "Build finished. Check the 'output/' directory in the repository for artifacts and logs."
