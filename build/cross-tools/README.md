# Build the Cross Compiler Toolchain

## Compiler Machine Types

Three machines must be distinguished when discussing toolchain creation:

 - The build machine, where the toolchain is built.
 - The host machine, where the toolchain will be executed.
 - The target machine, where the binaries created by the toolchain are executed.

The four common build types that are possible for toolchains are:

 - *Native build* (i.e. `BUILD==HOST==TARGET`)

   Used to build gcc for your workstation.

 - *Cross-build* (i.e. `BUILD==HOST!=TARGET`)

   Used to build a toolchain that works on your workstation but generates binaries for your target.

 - *Cross-native build* (i.e. `BUILD!=HOST==TARGE`T)

   Used to build a toolchain that works on your target and generates binaries for your target.

 - *Canadian toolchain* (i.e. `BUILD!=HOST!=TARGET`)
 
   Used to build ARCHITECTURE A a toolchain runs on B and generates binary for architecture C.

For the purpose of this exercise, I will be building a Cross-build compiler which will be run on a build machine used to create binaries for my target machine. The target machine will then have all of the necessary tools to recompile itself natively.

Since this is being built in a Debian VM, the following triplets will be used:

```
BUILD=x86_64-linux-gnu
HOST=x86_64-linux-gnu
TARGET=x86_64-linux-musl
```

Since the toolchain can be run from any Debian VM, the target can be anything in the future (e.g. `aarch64-linux-musl`, `riscv64-linux-musl`, etc.).

