#!/bin/sh -e
#
# Cross Tools - environment setup

BUILD_USER=build

TARGET_FS_DIR="${CROSS_ROOT_DIR}"/target-fs

printf 'TARGET_FS_DIR=%s\n\n' "${TARGET_FS_DIR}" >> /home/"${BUILD_USER}"/.bashrc
printf 'export TARGET_FS_DIR\n\n' >> /home/"${BUILD_USER}"/.bashrc

# Add the new tooling to the build user's environment.
printf 'CC="%s-gcc --sysroot=%s"\n' "${CROSS_TARGET}" "${TARGET_FS_DIR}" >> /home/"${BUILD_USER}"/.bashrc
printf 'CXX="%s-g++ --sysroot=%s"\n' "${CROSS_TARGET}" "${TARGET_FS_DIR}" >> /home/"${BUILD_USER}"/.bashrc
printf 'LD="%s-ld --sysroot=%s"\n' "${CROSS_TARGET}" "${TARGET_FS_DIR}" >> /home/"${BUILD_USER}"/.bashrc
printf 'AR=%s-ar\n' "${CROSS_TARGET}" >> /home/"${BUILD_USER}"/.bashrc
printf 'AS=%s-as\n' "${CROSS_TARGET}" >> /home/"${BUILD_USER}"/.bashrc
printf 'RANLIB=%s-ranlib\n' "${CROSS_TARGET}" >> /home/"${BUILD_USER}"/.bashrc
printf 'READELF=%s-readelf\n' "${CROSS_TARGET}" >> /home/"${BUILD_USER}"/.bashrc
printf 'STRIP=%s-strip\n\n' "${CROSS_TARGET}" >> /home/"${BUILD_USER}"/.bashrc

printf 'export CC\n' >> /home/"${BUILD_USER}"/.bashrc
printf 'export CXX\n' >> /home/"${BUILD_USER}"/.bashrc
printf 'export LD\n' >> /home/"${BUILD_USER}"/.bashrc
printf 'export AR\n' >> /home/"${BUILD_USER}"/.bashrc
printf 'export AS\n' >> /home/"${BUILD_USER}"/.bashrc
printf 'export RANLIB\n' >> /home/"${BUILD_USER}"/.bashrc
printf 'export READELF\n' >> /home/"${BUILD_USER}"/.bashrc
printf 'export STRIP\n' >> /home/"${BUILD_USER}"/.bashrc

# Prepare the target directories and permissions.
mkdir -p "${TARGET_FS_DIR}"
chown -R "${BUILD_USER}":"${BUILD_GROUP}" "${TARGET_FS_DIR}"

