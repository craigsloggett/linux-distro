#!/bin/sh
#
# Enter a Linux chroot.

set -e

log() {
	printf '%s %s\n' "-> $*"
}

# Check if a filesystem has been mounted.
mounted() {
	# Check if supplied mount point is a valid file/directory.
	[ -e "$1" ]         || return 1

	# Check the kernel for mounted filesystems.
	[ -e /proc/mounts ] || return 1

	# Check if the target directory is mounted.

	# We know the structure of the output of /proc/mounts [1]:
	# | The first column specifies the device that is mounted, the second column reveals the 
	# | mount point, and the third column tells the file system type, and the fourth column 
	# | tells you if it is mounted read-only (ro) or read-write (rw). The fifth and sixth 
	# | columns are dummy values designed to match the format used in /etc/mtab. 

	# [1] https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/4/html/reference_guide/s2-proc-mounts
	while read -r _ target; do
		[ "$target" = "$1" ] && return 0
	done < /proc/mounts

	return 1
}

clean() {
	# Cleanup the mounted filesystems.
	log "Unmounting /dev, /proc and /sys from chroot."
	{
        	umount "$1/sys/firmware/efi/efivars" 2>/dev/null || :
        	umount "$1/dev"  || :
        	umount "$1/proc" || :
        	umount "$1/sys"  || :
	}
}

main() {

	# Mount the Kernel ABI filesystems in the chroot environment.
	log "Mounting dev, proc and sys from host."
	{
		mounted "$1/dev"  || mount -o bind /dev "$1/dev"    || :
		mounted "$1/proc" || mount -t proc proc "$1/proc"   || :
		mounted "$1/sys"  || mount -t sysfs sys  "$1/sys"   || :
	}

	# Use a trap to cleanup the mounted filesystems on exit.

	# trap
	#
	# [action] [condition...]
	#
	# Do an action when a given condition is met.
	# | The condition can be EXIT, 0 (equivalent to EXIT), or a signal
	# | specified using a symbolic name, without the SIG prefix, as
	# | listed in the tables of signal names in the <signal.h> header
	# | defined in the Base Definitions volume of POSIX.1‐2017, Chapter
	# | 13, Headers; for example, HUP, INT, QUIT, TERM.
	trap 'clean "$1"' EXIT INT

	# Explicitly specify the environment variables for the chroot.

	# env
	#
	# -i Invoke utility with exactly the environment specified by the arguments; the inherited 
	#    environment shall be ignored completely.

	log "Entering chroot." 
	{
		chroot "$1" /usr/bin/env -i \
			HOME=/root \
			TERM="$TERM" \
			SHELL=/bin/sh \
			USER=root \
			CFLAGS="${CFLAGS:--march=x86-64 -mtune=generic -pipe -Os}" \
			CXXFLAGS="${CXXFLAGS:--march=x86-64 -mtune=generic -pipe -Os}" \
			MAKEFLAGS="${MAKEFLAGS:--j$(nproc 2>/dev/null || echo 1)}" \
			/bin/sh 
	}
}

main "$@"
