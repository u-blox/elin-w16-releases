#!/bin/bash
set -e

IMG_PATH=$2

# Images
MLO=MLO
UBOOT=u-boot.img
KERNEL=zImage
FDT=zImage-am335x-elin-w160-evk.dtb
ROOTFS=core-image-ublox-dev-elin-w160-evk.ubi

print_help () {
        echo Usage: ./elin-w16-flashload [target] [path]
        echo
        echo Ensure that the target has loaded U-Boot and dfu mode is enabled
        echo before the script is executed
        echo
        echo Arguments
        echo -e "\ttarget:  partition to program [all, bootloader, kernel, fdt, rootfs]"
        echo -e "\tpath: path firmware binaries"
        echo
}

echo ELIN-W16 USB DFU firmware programmer
echo

if [ $# != 2 ]; then
        echo "Error: missing arguments"
        echo
        print_help
        exit 1
fi

if [ ! -d $2 ]; then
        echo "Directory not found $2"
        print_help
        exit 1
fi

if [[ $1 == "all" || $1 == "bootloader" ]]
then
	dfu-util -a spl1 -D $IMG_PATH/$MLO -t 20000
	dfu-util -a bootloader -D $IMG_PATH/$UBOOT -t 20000
fi

if [[ $1 == "all" || $1 == "kernel" ]]
then
	dfu-util -a kernel -D $IMG_PATH/$KERNEL -t 20000
fi

if [[ $1 == "all" || $1 == "fdt" ]]
then
	dfu-util -a fdt -D $IMG_PATH/$FDT -t 20000
fi

if [[ $1 == "all" || $1 == "rootfs" ]]
then
	dfu-util -a rootfs -D $IMG_PATH/$ROOTFS -t 20000 -R
fi
