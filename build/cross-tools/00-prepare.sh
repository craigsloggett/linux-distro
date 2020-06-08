#!/bin/sh -e
#
# Cross Tools - Prepare the build environment.

BUILD_USER=build
BUILD_GROUP=build
CROSS_TOOLS_DIR=/home/"${BUILD_USER}"/cross-tools

# Create a build user (non-root).
getent group "${BUILD_GROUP}" > /dev/null || groupadd "${BUILD_GROUP}"
id -u "${BUILD_USER}" > /dev/null || useradd -s /bin/bash -g "${BUILD_GROUP}" -m -k /dev/null "${BUILD_USER}"

# Setup their environment.
cat > /home/"${BUILD_USER}"/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\n\$ ' /bin/bash
EOF

cat > /home/"${BUILD_USER}"/.bashrc << "EOF"
set +h
umask 022

LC_ALL=POSIX
PATH=/tools/bin:/bin:/usr/bin

export LC_ALL
export PATH

BUILD_TRIPLET="x86_64-linux-gnu"
HOST_TRIPLET="x86_64-linux-gnu"
TARGET_TRIPLET="x86_64-linux-musl"

export BUILD_TRIPLET
export HOST_TRIPLET
export TARGET_TRIPLET

unset CFLAGS
unset CXXFLAGS

EOF

chmod 0644 /home/"${BUILD_USER}"/.bashrc
chmod 0644 /home/"${BUILD_USER}"/.bash_profile

chown "${BUILD_USER}":"${BUILD_GROUP}" /home/"${BUILD_USER}"/.bashrc
chown "${BUILD_USER}":"${BUILD_GROUP}" /home/"${BUILD_USER}"/.bash_profile

# Prepare the build directories and permissions.
mkdir -p "${CROSS_TOOLS_DIR}"
mkdir -p "${CROSS_TOOLS_DIR}"/source

chmod 777 "${CROSS_TOOLS_DIR}"/source

chown -R "${BUILD_USER}":"${BUILD_GROUP}" "${CROSS_TOOLS_DIR}"

# Link the directory containing the compiled tools to the build system. 
# 
# This enables the toolchain to be compiled such that it always refers to 
# /cross-tools. This way, the compiler, assembler and linker will work in the 
# build environment and the chrooted environment just the same.
ln -sv "${CROSS_TOOLS_DIR}"/cross-tools /

# Add the build directory to their environment.
printf 'CROSS_TOOLS_DIR=%s \n\nexport CROSS_TOOLS_DIR\n' "${CROSS_TOOLS_DIR}" >> /home/"${BUILD_USER}"/.bashrc

