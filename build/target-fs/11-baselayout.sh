#!/bin/sh -e
#
# Base system layout build script.

# Setup /.
for d in bin boot dev etc home lib/firmware lib/modules mnt opt sbin srv; do
    install -dm 755 "${TARGET_FS_DIR}/$d"
done

install -dm 555  "${TARGET_FS_DIR}/proc"
install -dm 555  "${TARGET_FS_DIR}/sys"
install -dm 0750 "${TARGET_FS_DIR}/root"
install -dm 1777 "${TARGET_FS_DIR}/tmp"

# Setup /var.
for d in cache lib local lock log opt run service spool; do
    install -dm 755 "${TARGET_FS_DIR}/var/$d"
done

install -dm 1777 "${TARGET_FS_DIR}/var/tmp"

# Setup /usr hierarchy.
for d in bin include lib sbin share src; do
    install -dm 755 "${TARGET_FS_DIR}/usr/$d"
done

# Setup /usr/local.
for d in bin include lib sbin share src; do
    install -dm 755 "${TARGET_FS_DIR}/usr/local/$d"
done

# Setup /usr/share/man.
for d in 1 2 3 4 5 6 7 8; do
    install -dm 755 "${TARGET_FS_DIR}/usr/share/man/man$d"
done

ln -s ../proc/self/mounts "${TARGET_FS_DIR}/etc/mtab"
ln -s ../man "${TARGET_FS_DIR}/usr/local/share/man"

# /etc skeleton files.
#
# TODO: put more /etc skeleton files here.

cat > ${TARGET_FS_DIR}/etc/passwd << "EOF"
root::0:0:root:/root:/bin/ash
nobody:x:65534:65534:nobody:/:/bin/false
EOF

cat > ${TARGET_FS_DIR}/etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
tape:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
nogroup:x:65533:
nobody:x:65534:
EOF

touch ${TARGET_FS_DIR}/var/log/lastlog
chmod 664 ${TARGET_FS_DIR}/var/log/lastlog
