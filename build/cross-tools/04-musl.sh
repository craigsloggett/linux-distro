#!/bin/sh -e
#
# Cross Tools - Build musl libc

BUILD_SRC_DIR="${CROSS_ROOT_DIR}"/source
BUILD_DEST_DIR="${CROSS_TOOLS_DIR}"/"${CROSS_TARGET}"

VERSION="1.1.23"

cd "${BUILD_SRC_DIR}"

# Download from upstream.
wget https://www.musl-libc.org/releases/musl-"${VERSION}".tar.gz
gunzip musl-"${VERSION}".tar.gz
tar -xf musl-"${VERSION}".tar

# Prepare the build folder.
mkdir -v build && cd build

# Configure the source.
../musl-"${VERSION}"/./configure   \
  CROSS_COMPILE="${CROSS_TARGET}"- \
  --prefix=/                       \
  --target="${CROSS_TARGET}"

# Compile the source.
make 
DESTDIR="${BUILD_DEST_DIR}" make install

# Add missing directory and link.
#mkdir -v "${BUILD_DEST_DIR}"/usr
#ln -sv "${BUILD_DEST_DIR}"/include "${BUILD_DEST_DIR}"/usr/include

# Cleanup.
cd ..
rm -rf build

