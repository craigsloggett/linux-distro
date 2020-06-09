#!/bin/sh -e
#
# Cross Tools - environment setup

TARGET_FS_DIR="${CROSS_ROOT_DIR}"/target-fs

cp "${CROSS_TOOLS_DIR}"/"${CROSS_TARGET}"/lib64/libgcc_s.so.1 "${TARGET_FS_DIR}"/lib/

"${CROSS_TARGET}"-strip "${TARGET_FS_DIR}"/lib/libgcc_s.so.1
