#!/system/bin/sh

mount -o remount,rw /system
mount -t rootfs -o remount,rw rootfs

/sbin/rngd -P -T 1 -s 1024 -t 0.25 -W 90
echo -16 > /proc/$(/sbin/busybox pgrep rngd)/oom_adj
renice 5 $(/sbin/busybox pgrep rngd)

mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system

