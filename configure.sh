#!/bin/sh -f

fetch_buildroot ()
{
	wget https://buildroot.org/downloads/buildroot-2016.02.tar.gz
	tar xjvf buildroot-2016.02.tar.gz
	mv buildroot-2016.02 buildroot
}

do_configure ()
{
	make BR2_EXTERNAL=$PWD/br-external -C buildroot O=$PWD/output/fancyboard qemu_x86_64_defconfig
}

if [ ! -d buildroot ]; then
	fetch_buildroot
fi

do_configure
