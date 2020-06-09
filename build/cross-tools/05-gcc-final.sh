#!/bin/sh -e
#
# Cross Tools - gcc (static)

BUILD_SRC_DIR="${CROSS_ROOT_DIR}"/source
BUILD_DEST_DIR="${CROSS_TOOLS_DIR}"/"${CROSS_TARGET}"

VERSION="10.1.0"
MPFR_VERSION="4.0.2"
GMP_VERSION="6.2.0"
MPC_VERSION="1.1.0"

cd "${BUILD_SRC_DIR}"

# Prepare the build folder.
mkdir -v build && cd build

# Configure the source.
../gcc-"${VERSION}"/./configure      \
  --prefix="${CROSS_TOOLS_DIR}"      \
  --build="${CROSS_HOST}"            \
  --host="${CROSS_HOST}"             \
  --target="${CROSS_TARGET}"         \
  --with-sysroot="${BUILD_DEST_DIR}" \
  --with-arch="${CROSS_CPU}"         \
  --disable-nls                      \
  --disable-libmudflap               \
  --disable-libsanitizer             \
  --disable-lto-plugin               \
  --disable-libssp                   \
  --disable-multilib                 \
  --enable-threads=posix             \
  --enable-shared                    \
  --enable-languages=c,c++           \
  --enable-c99                       \
  --enable-long-long                 \
  --enable-clocale=generic           \
  --enable-libstdcxx-time            \
  --enable-fully-dynamic-string      \

# Compile the source.
make
make install

# Cleanup.
cd ..
rm -rf build

