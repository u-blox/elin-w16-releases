#!/bin/bash

print_help () {
        echo Usage: ./ramload-uboot.sh /dev/ttyUSB2 u-boot-spl.bin u-boot.img
        echo 
        echo Arguments
        echo -e "\tFirst:  Serial device to connect to the target"
        echo -e "\tSecond: Path to U-boot images (MLO, SPL, U-boot image)"
        echo
}

echo ELIN-W16 U-Boot RAM download script
echo

if [ $# != 2 ]; then
        echo "Error: missing arguments"
        echo
        print_help
        exit 1
fi

if [ ! -c $1 ]; then
        echo "No serial device found $1"
        print_help
        exit 1
fi

if [ ! -d $2 ]; then
        echo "Directory not found $2"
        print_help
        exit 1
fi

MLO=$2/MLO
SPL_IMG=$2/spl/u-boot-spl.bin
UBOOT_IMG=$2/u-boot.img

if [ ! -f $MLO ]; then
        echo "Missing MLO for firmware upgrade. $MLO"
        print_help
        exit 1
fi

if [ ! -f $SPL_IMG ]; then
	if [ ! -f $2/u-boot-spl.bin ]; then
		echo "Missing SPL image $SPL_IMG"
		print_help
		exit 1
	else
		SPL_IMG=$2/u-boot-spl.bin
	fi
fi

if [ ! -f $2/u-boot.img ]; then
        echo "Missing U-boot image $UBOOT_IMG"
        print_help
        exit 1
fi

stty -F $1 115200 cs8 -cstopb -parity -icanon min 1 time 1

sz --xmodem $SPL_IMG < $1 > $1

if [ $? == 0 ]; then
        echo U-boot SPL image loaded! 
        sz --ymodem  $UBOOT_IMG < $1 > $1
        if [ $? == 0 ]; then
		minicom -b 115200 -D $1 
   echo
        else
                echo U-boot image loading failed!
        fi
else
        echo U-boot SPL image loading failed!
        exit 1
fi
echo "U-Boot RAM download complete"
