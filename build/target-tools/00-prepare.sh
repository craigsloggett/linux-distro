#!/bin/sh -e
#
# Cross Tools - environment setup

BUILD_USER=build

TARGET_TOOLS_DIR="${CROSS_ROOT_DIR}"/target-tools

# Add the new tooling to the build user's environment.
printf 'export CC="%s-gcc --sysroot=%s"' "${CROSS_TARGET}" "${TARGET_TOOLS_DIR}" >> /home/"${BUILD_USER}"/.bashrc
printf 'export CXX="%s-g++ --sysroot=%s"' "${CROSS_TARGET}" "${TARGET_TOOLS_DIR}" >> /home/"${BUILD_USER}"/.bashrc
printf 'export LD="%s-ld --sysroot=%s" '"${CROSS_TARGET}" "${TARGET_TOOLS_DIR}" >> /home/"${BUILD_USER}"/.bashrc
printf 'export AR=%s-ar' "${CROSS_TARGET}" >> /home/"${BUILD_USER}"/.bashrc
printf 'export AS=%s-as' "${CROSS_TARGET}" >> /home/"${BUILD_USER}"/.bashrc
printf 'export RANLIB=%s-ranlib' "${CROSS_TARGET}" >> /home/"${BUILD_USER}"/.bashrc
printf 'export READELF=%s-readelf' "${CROSS_TARGET}" >> /home/"${BUILD_USER}"/.bashrc
printf 'export STRIP=%s-strip' "${CROSS_TARGET}" >> /home/"${BUILD_USER}"/.bashrc

# Prepare the build directories and permissions.
mkdir -p "${TARGET_TOOLS_DIR}"
chown -R "${BUILD_USER}":"${BUILD_GROUP}" "${TARGET_TOOLS_DIR}"

