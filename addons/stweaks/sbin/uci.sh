#!/system/bin/sh

mount -o remount,rw /system
mount -t rootfs -o remount,rw rootfs

chmod -R 755 /res/customconfig/actions
chmod 755 /res/uci.sh
/system/bin sh /res/uci.sh apply
rm /data/.maxfour/customconfig.xml
rm /data/.maxfour/action.cache

mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system

