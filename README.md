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

 - [ ] Write shell script to setup the base filesystem layout (based on FHS).
 - [ ] Populate default configuration files.
 - [ ] Define base packages (compiler, base toolset(s), init, libc, tls, shell, and their dependencies).

## package manager

 - [ ] Compile source code from upstream sources.
 - [ ] Handle run-time dependencies.
 - [ ] Handle build-time dependencies.

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
