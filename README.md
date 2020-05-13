# linux-distro

I have started work on what will be a new Linux Distribution. The intended audience will be myself, as I aim to create a distribution that can be managed effectively by one person.

The system will not use binary packages, but instead compile everything from upstream sources. A package manager will be developed to help facilitate this.

The following decisions have been made on the implementation:

 - `runit` will be used as the system's init system.
 - `sbase` will be used as the system's core UNIX toolset. 
 - `ubase` will be used as the system's core Linux toolset. 
 - `musl` will be used as the system's libc implementation.
 - `dash` will be used as the system's default shell.
 - `gcc` will be used as the system's C99 compiler (hard requirement for the Linux kernel).
 - `libressl` will be used as the system's TLS implementation.

## tasks

 - [ ] Write shell script to setup a chroot environment for installation.
 - [ ] Write shell script to setup the base filesystem layout (based on FHS).
 - [ ] Populate default configuration files.
 - [ ] Define base packages (compiler, base toolset(s), init, libc, tls, shell, and their dependencies).
 - [ ] Write installation instructions.

## package manager

 - [ ] Compile source code from upstream sources.
 - [ ] Handle run-time dependencies.
 - [ ] Handle build-time dependencies.

## installation instructions (WIP)

 1. Boot into any live Linux distribution.
 1. Prepare the disks.
 1. Mount the disks to `/mnt`.
 1. Create a `chroot` environment in `/mnt` (dev, proc, sys).
 1. `chroot` into this environment.
 1. Create the base filesystem layout.
 1. Install skeleton configuration files.
 1. ...Exit the `chroot` environment?
 1. ...Compile all the necessary base packages (from the host) into the `chroot`?

### directory structure of packages

```
baselayout/        # Package name.
├── build          # Build script.
├── sources        # Remote and local sources.
└── version        # Package version.

# Optional files.

├── pre-remove     # Pre-remove script (chmod +x).
├── post-install   # Post-install script (chmod +x).
├── depends        # Dependencies (usually required).
├── patches/       # Directory to store patches.
└── files/         # Directory to store misc files.
```
