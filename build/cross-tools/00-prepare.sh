#!/bin/sh -e
#
# Cross Tools - environment setup

BUILD_USER=build
BUILD_GROUP=build

CROSS_TARGET=x86_64-linux-musl
CROSS_ARCH=x86
CROSS_CPU=x86-64
CROSS_ROOT_DIR=/home/"${BUILD_USER}"/build-root
CROSS_TOOLS_DIR="${CROSS_ROOT_DIR}"/cross-tools

# Create a build user (non-root).
getent group "${BUILD_GROUP}" > /dev/null 2>&1 || groupadd "${BUILD_GROUP}"
id -u "${BUILD_USER}" > /dev/null 2>&1 || useradd -s /bin/bash -g "${BUILD_GROUP}" -m -k /dev/null "${BUILD_USER}"

# Setup their environment.
cat > /home/"${BUILD_USER}"/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\n\$ ' /bin/bash
EOF

cat > /home/"${BUILD_USER}"/.bashrc << "EOF"
set +h
umask 022

LC_ALL=POSIX
EOF

# Add the build directory to their environment.
printf 'PATH=%s:/bin:/usr/bin\n\n' "${CROSS_TOOLS_DIR}/bin" >> /home/"${BUILD_USER}"/.bashrc

cat >> /home/"${BUILD_USER}"/.bashrc << "EOF"
CROSS_BUILD=x86_64-linux-gnu
CROSS_HOST=x86_64-linux-gnu
EOF

# Add the build directory to their environment.
printf 'CROSS_TARGET=%s\n\n' "${CROSS_TARGET}" >> /home/"${BUILD_USER}"/.bashrc
printf 'CROSS_ARCH=%s\n' "${CROSS_ARCH}" >> /home/"${BUILD_USER}"/.bashrc
printf 'CROSS_CPU=%s\n\n' "${CROSS_CPU}" >> /home/"${BUILD_USER}"/.bashrc
printf 'CROSS_ROOT_DIR=%s\n' "${CROSS_ROOT_DIR}" >> /home/"${BUILD_USER}"/.bashrc
printf 'CROSS_TOOLS_DIR=%s\n\n' "${CROSS_TOOLS_DIR}" >> /home/"${BUILD_USER}"/.bashrc

cat >> /home/"${BUILD_USER}"/.bashrc << "EOF"
export LC_ALL
export PATH

export CROSS_BUILD
export CROSS_HOST
export CROSS_TARGET

export CROSS_ARCH
export CROSS_CPU

export CROSS_ROOT_DIR
export CROSS_TOOLS_DIR

unset CFLAGS
unset CXXFLAGS

EOF

chmod 0644 /home/"${BUILD_USER}"/.bashrc
chmod 0644 /home/"${BUILD_USER}"/.bash_profile

chown "${BUILD_USER}":"${BUILD_GROUP}" /home/"${BUILD_USER}"/.bashrc
chown "${BUILD_USER}":"${BUILD_GROUP}" /home/"${BUILD_USER}"/.bash_profile

# Prepare the build directories and permissions.
mkdir -p "${CROSS_ROOT_DIR}"
mkdir -p "${CROSS_ROOT_DIR}"/source
mkdir -p "${CROSS_TOOLS_DIR}"
mkdir -p "${CROSS_TOOLS_DIR}"/"${CROSS_TARGET}"
ln -sf . "${CROSS_TOOLS_DIR}"/"${CROSS_TARGET}"/usr

chmod 777 "${CROSS_ROOT_DIR}"/source

chown -R "${BUILD_USER}":"${BUILD_GROUP}" "${CROSS_ROOT_DIR}"

