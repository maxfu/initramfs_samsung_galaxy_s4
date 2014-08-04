#!/system/bin/sh

mount -o remount,rw /system
mount -t rootfs -o remount,rw rootfs

# Pre-config wolfson sound control if on GT-I9500
if [ -d /sys/class/misc/wolfson_control ]; then
    echo "0x0FA4 0x0404 0x0170 0x1DB9 0xF233 0x040B 0x08B6 0x1977 0xF45E 0x040A 0x114C 0x0B43 0xF7FA 0x040A 0x1F97 0xF41A 0x0400 0x1068" > /sys/class/misc/wolfson_control/eq_sp_freqs
    echo 11 > /sys/class/misc/wolfson_control/eq_sp_gain_1
    echo -7 > /sys/class/misc/wolfson_control/eq_sp_gain_2
    echo 4 > /sys/class/misc/wolfson_control/eq_sp_gain_3
    echo -10 > /sys/class/misc/wolfson_control/eq_sp_gain_4
    echo -0 > /sys/class/misc/wolfson_control/eq_sp_gain_5
    echo 1 > /sys/class/misc/wolfson_control/switch_eq_speaker
fi

mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
