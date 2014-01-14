#!/sbin/busybox sh
# AdaMax kernel script (Root helper by Wanam)
# Used to be adam.sh by Wanam
# Modified by MaxFu

/sbin/busybox mount -t rootfs -o remount,rw rootfs

#Disable knox seandroid
pm disable com.sec.knox.seandroid
setenforce 0

#Disable more knox stuff
pm disable com.sec.knox.eventsmanager
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

# init.d support
if [ -d /system/etc/init.d ]; then
  /sbin/busybox run-parts /system/etc/init.d
fi

/sbin/busybox mount -t rootfs -o remount,ro rootfs
