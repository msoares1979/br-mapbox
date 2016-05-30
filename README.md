# Buildroot External for Mapbox

This external extension contains packages definitions for building the [Mapbox
Qt SDK][2] for [Buildroot][1].

These configurations where heavily inspired on [meta-mapbox][3] Github
repository.

## Dependencies

- Toolchain with C++ support
- Toolchain with wchar support
- OpenGL or OpenGL ES2 support
- Qt5 modules


## Usage

There is a `configure.sh` script to automate your building. It basically fetches
2016-02 version of buildroot and points it to the `br-external` structure.

    make BR2_EXTERNAL=$PWD/br-external -C buildroot O=$PWD/output/fancyboard qemu_x86_64_defconfig
    cd output/fancyboard

Enable GlibC on the toolchain configuration.

    make menuconfig
	Toolchain -> Enable C++ Support

Select an OpenGL EL or OpenGL ES2 implementation, e.g. Mesa:

    Target Packages -> Graphical Libraries -> mesa3d
	[x] Gallium swrast driver
	[x] OpenGL ES

Check for mapbox packages configuration

    User-Provided options -> Mapbox packages -> ...

Enable framebuffer device on kernel

    make linux-menuconfig
	Device Drivers -> Graphics Support -> QXL Virtual GPU

Build all packages.

	make

Run `qemu` with the following options.

    qemu-system-x86_64 -M pc -kernel images/bzImage -drive file=images/rootfs.ext2,if=ide,format=raw -append root=/dev/sda -net nic,model=rtl8139 -net user -vga qxl


## Caveats

- Does not compile on UCLIBC-based toolchain
- `qemu_x86_64_defconfig` target is not a good choice due to its bad framebuffer
  support
- Not tested on real hardware



[1]: https://buildroot.org
[2]: https://github.com/mapbox/mapbox-gl-native/tree/master/platform/qt
[3]: https://github.com/mapbox/meta-mapbox
