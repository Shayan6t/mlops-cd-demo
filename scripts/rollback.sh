#!/usr/bin/env bash
set -euo pipefail

# Rollback script for mlops-api container
# Usage: ./scripts/rollback.sh <TARGET_VERSION> [IMAGE_REPO]

TARGET_VERSION="${1:-1.0.0}"
IMAGE_REPO="${2:-ghcr.io/shayan6t/mlops-cd-demo}"
TARGET_IMAGE="${IMAGE_REPO}:${TARGET_VERSION}"

echo "============================================="
echo "Initiating Rollback to Version: ${TARGET_VERSION}"
echo "Target Image: ${TARGET_IMAGE}"
echo "============================================="

echo "1. Pulling verified immutable target image..."
docker pull "${TARGET_IMAGE}" || echo "Using local cached image..."

echo "2. Stopping currently running container..."
docker stop mlops-api || true

echo "3. Removing currently running container..."
docker rm mlops-api || true

echo "4. Launching rolled-back container version ${TARGET_VERSION}..."
docker run -d \
  --name mlops-api \
  --restart unless-stopped \
  -p 5000:5000 \
  "${TARGET_IMAGE}"

echo "5. Verifying health endpoint..."
sleep 3
curl -s --fail http://localhost:5000/health || (echo "Health check failed!" && exit 1)

echo ""
echo "============================================="
echo "Rollback to ${TARGET_VERSION} completed successfully!"
echo "============================================="
