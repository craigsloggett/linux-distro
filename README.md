# linux-distro

I have started work on what will be a new Linux Distribution. The intended audience will be myself, as I aim to create a distribution that can be managed effectively by one person.

The system will not use binary packages, but instead compile everything from upstream sources. A package manager will be developed to help facilitate this.

The following decisions have been made on the implementation:

 - `busybox` will be used as the system's init system.
 - `busybox` will be used as the system's process manager.
 - `busybox` will be used as the system's core UNIX toolset.
 - `busybox` will be used as the system's core Linux toolset.
 - `busybox`/`dash` will be used as the system's default shell.
 - `musl` will be used as the system's libc implementation.
 - `gcc` will be used as the system's C99 compiler (hard requirement for the Linux kernel).
 - `libressl` will be used as the system's TLS implementation.

## tasks

 - [ ] Write shell script to setup a chroot environment for installation.
 - [x] Write shell script to setup the filesystem layout (based on FHS).
 - [ ] Prepare the build system.
 - [ ] Build Stage 1 - temporary toolchain capable of producing executables for the target platform.
 - [ ] Build Stage 2 - temporary system, native to the target platform.
 - [ ] Build Stage 3 - full native system, native to the target platform.
 - [ ] Populate default configuration files.
 - [ ] Define base packages (compiler, base toolset(s), init, libc, tls, shell, and their dependencies).
 - [ ] Write installation instructions.

## Tested Builds

| Host         | Target      | Build Status   |
| ------------ | ----------- | -------------- | 
| x86_64-musl  | x86_64-musl | Pending        |
| x86_64-glibc | x86_64-musl | Pending        |

### Write a shell script to setup the filesystem layout (based on FHS).

Version 3.0 of the FHS is being used and can be found here: https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html

*Base Layout*
```
/
├── bin
├── boot
├── dev
├── etc
├── home
├── lib
├── media
├── mnt
├── opt
├── root
├── run
├── sbin
├── srv
├── tmp
├── usr
│   ├── bin
│   ├── lib
│   ├── local
│   ├── sbin
│   └── share
└── var
    ├── cache
    ├── lib
    ├── local
    ├── lock
    ├── log
    ├── opt
    ├── run
    ├── spool
    └── tmp
```

*Linux Specific*
```
/
└── dev
    ├── null
    ├── tty
    └── zero
```

Fun fact about the `/home` directory:

>User specific configuration files for applications are stored in the user's home directory in a file that starts with the '.' character (a "dot file"). If an application needs to create more than one dot file then they should be placed in a subdirectory with a name starting with a '.' character, (a "dot directory"). In this case the configuration files should not start with the '.' character.

https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s08.html#homeReferences

### Prepare the build system.

For the build system, I will be using Void Linux live install image to build the necessary stages used to bootstrap the distribution.

*Bare Minimum*
 - [ ] Boot into Void Linux live install image.
 - [ ] Use the regular user (ensure sudo permissions).
 - [ ] Install the necessary tools needed to download and compile software from source.
 - [ ] Partition the destination disk (physical disk).
 - [ ] Create the necessary filesystems on the destination disk.
 - [ ] Mount the destination disk on `/build` and `/build/boot` accordingly.
 - [ ] Turn on swap: `swapon -v /dev/xxxx`

*Prepare to Build the Toolchain*
 - [ ] Create a directory to store upstream source files: `/build/source`
 - [ ] Create a directory to store the compiled tools: `/build/tools`
 - [ ] We need to create a link between the build system: `ln -sv /build/tools /`
 - [ ] Download all toolchain source files.

```
# Build Tools (and dependencies)
linux - http://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.14.tar.xz
gcc - https://gcc.gnu.org/pub/gcc/releases/gcc-10.1.0/gcc-10.1.0.tar.xz
 - gmp - https://gmplib.org/download/gmp/gmp-6.2.0.tar.xz
 - mpfr - https://ftp.gnu.org/gnu/mpfr/mpfr-4.0.2.tar.xz
 - mpc - https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz
binutils - https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.xz
 - flex - https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz
   - m4 - https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz
   - make - https://ftp.gnu.org/gnu/make/make-4.3.tar.gz
 - zlib - https://zlib.net/zlib-1.2.11.tar.gz
bison - https://ftp.gnu.org/gnu/bison/bison-3.6.2.tar.xz
musl - https://www.musl-libc.org/releases/musl-1.2.0.tar.gz

# (De)compression Utilities
bzip2 - https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
gzip (pigz) - https://zlib.net/pigz/pigz-2.4.tar.gz
xz - https://nchc.dl.sourceforge.net/project/lzmautils

# Helpful Utilities
pkgconf - https://distfiles.dereferenced.org/pkgconf/pkgconf-1.6.3.tar.xz

# System Applications
busybox - https://busybox.net/downloads/busybox-1.31.1.tar.bz2
 - libressl - https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-3.1.2.tar.gz
```

*Configure Compiler*
...

## package manager

 - [ ] Compile source code from upstream sources.
 - [ ] Handle run-time dependencies.
 - [ ] Handle build-time dependencies.

## installation instructions

 1. Boot into a live Linux distribution with musl support (must be able to compile with musl).
 1. Prepare the disks.
 1. Mount the disks to `/mnt`.
 1. Create a `chroot` environment in `/mnt` (dev, proc, sys).
 1. `chroot` into this environment.
 1. Create the base filesystem layout.
 1. Install skeleton configuration files.
 1. ...Exit the `chroot` environment?
 1. ...Compile all the necessary base packages (from the host) into the `chroot`?

