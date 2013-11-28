Initramfs for Samsung Galaxy S4 Series Kernels
===================================
Including GT-I9500, GT-I9502 and SCH-I959

How to Use:
-----------------------------------
    1. Compile a zImage
        cd {your source}/
        edit make_kernel.sh change i9502 to i9500 or i959 which should be your device.
        ./make_kernel.sh
    2. To make a initramfs cpio image
        cp -a {your device}/boot-ramdisk {your place}/
        cd {your source}/
        find -name 'zImage' -exec cp -av {} {your place}/ \;
        find -name '*.ko' -exec cp -av {} {your place}/boot-ramdisk/lib/modules/ \;
        chmod -R g-w {your place}/boot-ramdisk/*
        cd {your place}/boot-ramdisk/
        find | cpio -H newc -o --quiet --file={your place}/boot-initramfs.cpio
        cd {your place}
        gzip -9 boot-initramfs.cpio
    3. Make a boot.img
        {correct place}/mkbootimg --kernel {your place}/zImage --ramdisk {your place}/boot-initramfs.cpio.gz --board universal5410 --base 0x10000000 --pagesize 2048 --ramdiskaddr 0x11000000 -o {your place}/boot.img
        Then the output is {your place}/boot.img
