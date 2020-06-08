#!/bin/sh -e
#
# Cross Tools - Linux Header Files

BUILD_SRC_DIR="${CROSS_TOOLS_DIR}"/source
BUILD_DEST_DIR="${CROSS_TOOLS_DIR}"/"${CROSS_TARGET}"

VERSION="5.6.14"
VERSION_MAJOR=`printf '%s\n' "${VERSION}" | cut -c1`

cd "${BUILD_SRC_DIR}"

# Download from upstream.
wget http://cdn.kernel.org/pub/linux/kernel/v"${VERSION_MAJOR}".x/linux-"${VERSION}".tar.xz
xz -d linux-"${VERSION}".tar.xz
tar -xf linux-"${VERSION}".tar

# Prepare the build folder.
mkdir -v build && cd build
cp -r ../linux-"${VERSION}"/* .

# Compile the source.
make mrproper
make ARCH="${CROSS_ARCH}" headers_check
make ARCH="${CROSS_ARCH}" headers

# Install the headers.
mkdir -v "${BUILD_DEST_DIR}"/include
cp -r usr/include/* "${BUILD_DEST_DIR}"/include

# Cleanup.
cd ..
rm -rf build

