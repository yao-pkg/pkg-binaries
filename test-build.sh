#!/bin/bash
set -e

echo "Testing Docker build for ARMv7 Node binaries..."

# Build the Docker image with Node 22
docker buildx build \
  --build-arg PKG_FETCH_OPTION_a=armv7 \
  --build-arg PKG_FETCH_OPTION_n=node22 \
  --file ./Dockerfile.linuxcross \
  --platform linux/arm/v7 \
  --output type=local,dest=test-dist \
  .

echo "Build completed. Checking output:"
ls -la test-dist/

# Clean up
echo "Cleaning up test files..."
rm -rf test-dist/

echo "Test completed successfully!"
