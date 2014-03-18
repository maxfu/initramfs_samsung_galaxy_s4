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

/sbin/busybox mount -o remount,rw /system
# Automatically install SuperSU
if [ ! -f /system/bin/su ] && [ ! -f /system/xbin/su ] && [ ! -f /system/bin/.ext/.su ]; then

    # Disabling OTA survival
    /sbin/busybox chattr -i /system/xbin/su
    /sbin/busybox -i /system/bin/.ext/.su
    /sbin/busybox -i /system/xbin/daemonsu
    /sbin/busybox -i /system/etc/install-recovery.sh

    # Removing old files
    /sbin/busybox rm -f /system/bin/su
    /sbin/busybox rm -f /system/xbin/su
    /sbin/busybox rm -f /system/xbin/daemonsu
    /sbin/busybox rm -f /system/bin/.ext/.su
    /sbin/busybox rm -f /system/etc/install-recovery.sh
    /sbin/busybox rm -f /system/etc/init.d/99SuperSUDaemon
    /sbin/busybox rm -f /system/etc/.has_su_daemon
    /sbin/busybox rm -f /system/etc/.installed_su_daemon
    /sbin/busybox rm -f /system/app/Superuser.apk
    /sbin/busybox rm -f /system/app/Superuser.odex
    /sbin/busybox rm -f /system/app/SuperUser.apk
    /sbin/busybox rm -f /system/app/SuperUser.odex
    /sbin/busybox rm -f /system/app/superuser.apk
    /sbin/busybox rm -f /system/app/superuser.odex
    /sbin/busybox rm -f /system/app/Supersu.apk
    /sbin/busybox rm -f /system/app/Supersu.odex
    /sbin/busybox rm -f /system/app/SuperSU.apk
    /sbin/busybox rm -f /system/app/SuperSU.odex
    /sbin/busybox rm -f /system/app/supersu.apk
    /sbin/busybox rm -f /system/app/supersu.odex
    /sbin/busybox rm -f /data/dalvik-cache/*com.noshufou.android.su*
    /sbin/busybox rm -f /data/dalvik-cache/*com.koushikdutta.superuser*
    /sbin/busybox rm -f /data/dalvik-cache/*com.mgyun.shua.su*
    /sbin/busybox rm -f /data/dalvik-cache/*Superuser.apk*
    /sbin/busybox rm -f /data/dalvik-cache/*SuperUser.apk*
    /sbin/busybox rm -f /data/dalvik-cache/*superuser.apk*
    /sbin/busybox rm -f /data/dalvik-cache/*eu.chainfire.supersu*
    /sbin/busybox rm -f /data/dalvik-cache/*Supersu.apk*
    /sbin/busybox rm -f /data/dalvik-cache/*SuperSU.apk*
    /sbin/busybox rm -f /data/dalvik-cache/*supersu.apk*
    /sbin/busybox rm -f /data/dalvik-cache/*.oat
    /sbin/busybox rm -f /data/app/com.noshufou.android.su-*
    /sbin/busybox rm -f /data/app/com.koushikdutta.superuser-*
    /sbin/busybox rm -f /data/app/com.mgyun.shua.su-*
    /sbin/busybox rm -f /data/app/eu.chainfire.supersu-*

    # Creating space
    /sbin/busybox mv /system/app/Maps.apk /Maps.apk
    /sbin/busybox mv /system/app/GMS_Maps.apk /GMS_Maps.apk
    /sbin/busybox mv /system/app/YouTube.apk /YouTube.apk

    # Placing files
    /sbin/busybox mkdir /system/bin/.ext
    /sbin/busybox cp /res/supersu/su /system/xbin/daemonsu
    /sbin/busybox cp /res/supersu/su /system/xbin/su
    /sbin/busybox cp /res/supersu/su /system/bin/.ext/.su
    /sbin/busybox cp /res/supersu/Superuser.apk /system/app/Superuser.apk
    /sbin/busybox cp /res/supersu/install-recovery.sh /system/etc/install-recovery.sh
    /sbin/busybox cp /res/supersu/99SuperSUDaemon /system/etc/init.d/99SuperSUDaemon
    /sbin/busybox echo 1 > /system/etc/.installed_su_daemon
    /sbin/busybox echo 1 > /system/etc/.has_su_daemon

    # Restoring files
    /sbin/busybox mv /Maps.apk /system/app/Maps.apk
    /sbin/busybox mv /GMS_Maps.apk /system/app/GMS_Maps.apk
    /sbin/busybox mv /YouTube.apk /system/app/YouTube.apk

    # Setting permissions
    /sbin/busybox chown 0.0 /system/bin/.ext
    /sbin/busybox chown 0:0 /system/bin/.ext
    /sbin/busybox chmod 0777 /system/bin/.ext

    /sbin/busybox chown 0.0 /system/bin/.ext/.su
    /sbin/busybox chown 0:0 /system/bin/.ext/.su
    /sbin/busybox chmod 06755 /system/bin/.ext/.su
    /system/bin/toolbox chcon u:object_r:system_file:s0 /system/bin/.ext/.su

    /sbin/busybox chown 0.0 /system/xbin/su
    /sbin/busybox chown 0:0 /system/xbin/su
    /sbin/busybox chmod 06755 /system/xbin/su
    /system/bin/toolbox chcon u:object_r:system_file:s0 /system/xbin/su

    /sbin/busybox chown 0.0 /system/xbin/daemonsu
    /sbin/busybox chown 0:0 /system/xbin/daemonsu
    /sbin/busybox chmod 0755 /system/xbin/daemonsu
    /system/bin/toolbox chcon u:object_r:system_file:s0 /system/xbin/daemonsu

    /sbin/busybox chown 0.0 /system/etc/install-recovery.sh
    /sbin/busybox chown 0:0 /system/etc/install-recovery.sh
    /sbin/busybox chmod 0755 /system/etc/install-recovery.sh
    /system/bin/toolbox chcon u:object_r:system_file:s0 /system/etc/install-recovery.sh

    /sbin/busybox chown 0.0 /system/etc/init.d/99SuperSUDaemon
    /sbin/busybox chown 0:0 /system/etc/init.d/99SuperSUDaemon
    /sbin/busybox chmod 0755 /system/etc/init.d/99SuperSUDaemon
    /system/bin/toolbox chcon u:object_r:system_file:s0 /system/etc/init.d/99SuperSUDaemon

    /sbin/busybox chown 0.0 /system/etc/.has_su_daemon
    /sbin/busybox chown 0:0 /system/etc/.has_su_daemon
    /sbin/busybox chmod 0644 /system/etc/.has_su_daemon
    /system/bin/toolbox chcon u:object_r:system_file:s0 /system/etc/.has_su_daemon

    /sbin/busybox chown 0.0 /system/etc/.installed_su_daemon
    /sbin/busybox chown 0:0 /system/etc/.installed_su_daemon
    /sbin/busybox chmod 0644 /system/etc/.installed_su_daemon
    /system/bin/toolbox chcon u:object_r:system_file:s0 /system/etc/.installed_su_daemon

    /sbin/busybox chown 0.0 /system/app/Superuser.apk
    /sbin/busybox chown 0:0 /system/app/Superuser.apk
    /sbin/busybox chmod 0644 /system/app/Superuser.apk
    /system/bin/toolbox chcon u:object_r:system_file:s0 /system/app/Superuser.apk

    /sbin/busybox chown 0.0 /system/app/Maps.apk
    /sbin/busybox chown 0:0 /system/app/Maps.apk
    /sbin/busybox chmod 0644 /system/app/Maps.apk
    /system/bin/toolbox chcon u:object_r:system_file:s0 /system/app/Maps.apk

    /sbin/busybox chown 0.0 /system/app/GMS_Maps.apk
    /sbin/busybox chown 0:0 /system/app/GMS_Maps.apk
    /sbin/busybox chmod 0644 /system/app/GMS_Maps.apk
    /system/bin/toolbox chcon u:object_r:system_file:s0 /system/app/GMS_Maps.apk

    /sbin/busybox chown 0.0 /system/app/YouTube.apk
    /sbin/busybox chown 0:0 /system/app/YouTube.apk
    /sbin/busybox chmod 0644 /system/app/YouTube.apk
    /system/bin/toolbox chcon u:object_r:system_file:s0 /system/app/YouTube.apk

    # Post-installation script
    /system/xbin/su --install

fi

# Install busybox if not present
if [ ! -f /system/xbin/busybox ]; then
    ln -s /sbin/busybox /system/xbin/busybox
    for i in $(/sbin/busybox --list); do
        if [ ! -f /system/xbin/$i ]; then
            /sbin/busybox ln -s /sbin/busybox /system/xbin/$i
        fi
    done
fi
/sbin/busybox mount -o remount,ro /system

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
