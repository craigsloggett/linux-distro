#!/bin/sh -e
#
# Cross Tools - binutils

BUILD_SRC_DIR="${CROSS_TOOLS_DIR}"/source
BUILD_DEST_DIR="${CROSS_TOOLS_DIR}"/"${CROSS_TARGET}"

VERSION="2.34"

cd "${BUILD_SRC_DIR}"

# Download from upstream.
wget https://ftp.gnu.org/gnu/binutils/binutils-"${VERSION}".tar.xz
xz -d binutils-"${VERSION}".tar.xz
tar -xf binutils-"${VERSION}".tar

# Prepare the build folder.
mkdir -v build && cd build

# Configure the Source
../binutils-"${VERSION}"/./configure \
  --prefix="${CROSS_TOOLS_DIR}"      \
  --with-sysroot="${BUILD_DEST_DIR}" \
  --target="${CROSS_TARGET}"         \
  --disable-nls                      \
  --disable-multilib

# Compile the source.
make configure-host
make -j4
make install 

# Cleanup.
cd ..
rm -rf build

