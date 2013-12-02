#!/sbin/busybox sh
# AdaMax kernel script (Root helper by Wanam)
# Used to be adam.sh by Wanam
# Modified by MaxFu

/sbin/busybox mount -t rootfs -o remount,rw rootfs

# Enable Kernel Samepage Merging
/sbin/busybox echo 1 > /sys/kernel/mm/ksm/run

#Disable knox
pm disable com.sec.knox.seandroid
pm disable com.sec.knox.app.container
pm disable com.sec.knox.store
pm disable com.sec.knox.containeragent
pm disable com.sec.enterprise.knox.attestation
pm disable com.sec.knox.eventsmanager
setenforce 0

# chown 0.0 /system/xbin/su
# chmod 06755 /system/xbin/su
# symlink /system/xbin/su /system/bin/su

# chown 0.0 /system/xbin/daemonsu
# chmod 06755 /system/xbin/daemonsu


# chown 0.0 /system/app/Superuser.apk
# chmod 0644 /system/app/Superuser.apk

# chown 0.0 /system/app/STweaks.apk
# chmod 0644 /system/app/STweaks.apk

if [ ! -f /system/xbin/busybox ]; then
ln -s /sbin/busybox /system/xbin/busybox
ln -s /sbin/busybox /system/xbin/pkill
fi

if [ ! -f /system/bin/busybox ]; then
ln -s /sbin/busybox /system/bin/busybox
ln -s /sbin/busybox /system/bin/pkill
fi

# chmod -R 755 /res/customconfig/actions

# rm /data/.adamkernel/customconfig.xml
# rm /data/.adamkernel/action.cache

/system/bin/setprop pm.sleep_mode 1
/system/bin/setprop ro.ril.disable.power.collapse 0
/system/bin/setprop ro.telephony.call_ring.delay 1000

sync

# /system/xbin/daemonsu --auto-daemon &

if [ -d /system/etc/init.d ]; then
  /sbin/busybox run-parts /system/etc/init.d
fi

# chmod 755 /res/uci.sh
# /res/uci.sh apply

/sbin/busybox mount -t rootfs -o remount,ro rootfs
