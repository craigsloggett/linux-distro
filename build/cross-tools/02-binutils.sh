#!/bin/sh -e
#
# Cross Tools - binutils

BUILD_DEST_DIR=/tools  # A place to store compiled binaries.
BUILD_USER=build
CROSS_TOOLS_DIR="${STAGE1_ROOT_DIR:-}"

VERSION="2.34"

TARGET_TRIPLET="${STAGE1_TARGET:-}"

cd "${CROSS_TOOLS_DIR}"/source

# Download from upstream.
wget https://ftp.gnu.org/gnu/binutils/binutils-"${VERSION}".tar.xz
xz -d binutils-"${VERSION}".tar.xz
tar -xf binutils-"${VERSION}".tar

# Prepare the build folder.
mkdir -v build && cd build

# Configure the Source
../binutils-"${VERSION}"/./configure      \
  --prefix="${BUILD_DEST_DIR}"            \
  --with-lib-path="${BUILD_DEST_DIR}"/lib \
  --with-sysroot="${CROSS_TOOLS_DIR}"      \
  --target="${TARGET_TRIPLET}"            \
  --disable-nls                           \
  --disable-werror

# Compile the source.
make -j4
make install 

# Cleanup.
cd ..
rm -rf build

