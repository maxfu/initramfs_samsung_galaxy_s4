#!/sbin/busybox sh
# AdaMax kernel script (Root helper by Wanam)
# Used to be adam.sh by Wanam
# Modified by MaxFu

/sbin/busybox mount -t rootfs -o remount,rw rootfs

#Disable knox
setenforce 0
pm disable com.sec.knox.eventsmanager
pm disable com.sec.knox.seandroid
pm disable com.sec.enterprise.knox.attestation
pm disable com.sec.knox.containeragent
pm disable com.sec.knox.app.container
pm disable com.sec.knox.store
pm disable com.samsung.klmsagent

# Enable Kernel Samepage Merging
/sbin/busybox echo 1 > /sys/kernel/mm/ksm/run

# Enable Entropy Generator
/sbin/rngd -P -T 1 -s 1024 -t 0.25 -W 90
/sbin/busybox echo -16 > /proc/$(/sbin/busybox pgrep rngd)/oom_adj
/sbin/busybox renice 5 $(/sbin/busybox pgrep rngd)

# Enable I/O Queue Extension
/sbin/busybox echo 1000 > /proc/sys/vm/dirty_expire_centisecs
/sbin/busybox echo 500 > /proc/sys/vm/dirty_writeback_centisecs
for node in $(/sbin/busybox find /sys -name nr_requests | /sbin/busybox grep mmcblk); do /sbin/busybox echo 1024 > $node; done

# Install busybox if not present
/sbin/busybox mount -o remount,rw /system
if [ ! -f /system/xbin/busybox ]; then
    ln -s /sbin/busybox /system/xbin/busybox
    for i in $(/sbin/busybox --list); do
        if [ ! -f /system/xbin/$i ]; then
            /sbin/busybox ln -s /sbin/busybox /system/xbin/$i
        fi
    done
fi
/sbin/busybox mount -o remount,ro /system

# STweaks support
chmod -R 755 /res/customconfig/actions
chmod 755 /res/uci.sh
/res/uci.sh apply

rm /data/.adamkernel/customconfig.xml
rm /data/.adamkernel/action.cache

/system/bin/setprop pm.sleep_mode 1
/system/bin/setprop ro.ril.disable.power.collapse 0
/system/bin/setprop ro.telephony.call_ring.delay 1000

sync

# Auto/Force root with koush's superuser
if [ ! -f /system/etc/.koush ]; then
    # Wipe other superuser suite
    /sbin/busybox mount -o remount,rw /system
    /sbin/busybox mount chattr -i /system/bin/su
    /sbin/busybox mount chattr -i /system/xbin/su
    /sbin/busybox mount rm -f /system/bin/su
    /sbin/busybox mount rm -f /system/xbin/su
    /sbin/busybox mount rm -f /system/app/Superuser.*
    /sbin/busybox mount rm -f /system/app/Supersu.*
    /sbin/busybox mount rm -f /system/app/superuser.*
    /sbin/busybox mount rm -f /system/app/supersu.*
    /sbin/busybox mount rm -f /system/app/SuperUser.*
    /sbin/busybox mount rm -f /system/app/SuperSU.*
    # Install koush's superuser
    /sbin/busybox cp /res/superuser/su /system/xbin/
    /sbin/busybox chown 0:0 /system/xbin/su
    /sbin/busybox chmod 6755 /system/xbin/su
    /sbin/busybox ln -s /system/xbin/su /system/bin/su
    /sbin/busybox cp /res/superuser/Superuser.apk /system/app/
    /sbin/busybox chmod 644 /system/app/Superuser.apk
    /sbin/busybox touch /system/etc/.koush
    /sbin/busybox mount -o remount,ro /system
fi

# Start superuser daemon
if [ -f /system/etc/.koush ]; then
    /system/xbin/su --daemon &
fi

# init.d support
if [ -d /system/etc/init.d ]; then
  /sbin/busybox run-parts /system/etc/init.d
fi

/sbin/busybox mount -t rootfs -o remount,ro rootfs
