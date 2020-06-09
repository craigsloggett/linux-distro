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

# Download from upstream.
wget https://gcc.gnu.org/pub/gcc/releases/gcc-"${VERSION}"/gcc-"${VERSION}".tar.xz
xz -d gcc-"${VERSION}".tar.xz
tar -xf gcc-"${VERSION}".tar

# Prepare GMP, MPFR and MPC.
wget https://ftp.gnu.org/gnu/mpfr/mpfr-"${MPFR_VERSION}".tar.xz
wget https://gmplib.org/download/gmp/gmp-"${GMP_VERSION}".tar.xz
wget https://ftp.gnu.org/gnu/mpc/mpc-"${MPC_VERSION}".tar.gz

xz -d mpfr-"${MPFR_VERSION}".tar.xz
xz -d gmp-"${GMP_VERSION}".tar.xz
gunzip mpc-"${MPC_VERSION}".tar.gz

tar -xf mpfr-"${MPFR_VERSION}".tar
tar -xf gmp-"${GMP_VERSION}".tar
tar -xf mpc-"${MPC_VERSION}".tar

mv mpfr-"${MPFR_VERSION}" gcc-"${VERSION}"/mpfr
mv gmp-"${GMP_VERSION}" gcc-"${VERSION}"/gmp
mv mpc-"${MPC_VERSION}" gcc-"${VERSION}"/mpc

# Prepare the build folder.
mkdir -v build && cd build

# Configure the source.
../gcc-"${VERSION}"/./configure      \
  --prefix="${CROSS_TOOLS_DIR}"      \
  --build="${CROSS_HOST}"            \
  --host="${CROSS_HOST}"             \
  --target="${CROSS_TARGET}"         \
  --with-sysroot="${BUILD_DEST_DIR}" \
  --with-arch="${CROSS_ARCH}"        \
  --with-newlib                      \
  --without-headers                  \
  --disable-nls                      \
  --disable-shared                   \
  --disable-multilib                 \
  --disable-decimal-float            \
  --disable-threads                  \
  --disable-libatomic                \
  --disable-libgomp                  \
  --disable-libitm                   \
  --disable-libquadmath              \
  --disable-libsanitizer             \
  --disable-libssp                   \
  --disable-libstdcxx                \
  --disable-libvtv                   \
  --enable-clocale=generic           \
  --enable-languages=c 

# Compile the source.
make -j4 all-gcc all-target-libgcc
make install-gcc install-target-libgcc

# Cleanup.
cd ..
rm -rf build

