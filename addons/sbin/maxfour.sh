#!/sbin/busybox sh
# AdaMax kernel script (Root helper by Wanam)
# Used to be adam.sh by Wanam
# Modified by MaxFu

# Pre-defined functions
set_perm() {
    /res/supersu chown $1.$2 $4
    /res/supersu chown $1:$2 $4
    /res/supersu chmod $3 $4
}

ch_con() {
	/system/bin/toolbox chcon u:object_r:system_file:s0 $1
	chcon u:object_r:system_file:s0 $1
}

/sbin/busybox mount -o remount,rw /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs

# Auto-Root
if [ ! -f /system/xbin/su ] && [ ! -f /system/bin/su ] && [ ! -f /system/bin/.ext/.su ]; then
    # Disabling OTA survival
    /sbin/busybox chattr -i /system/xbin/su
    /sbin/busybox chattr -i /system/bin/.ext/.su
    /sbin/busybox chattr -i /system/xbin/daemonsu
    /sbin/busybox chattr -i /system/etc/install-recovery.sh
    # Removing old files
    /sbin/busybox rm -f /system/bin/su
    /sbin/busybox rm -f /system/xbin/su
    /sbin/busybox rm -f /system/xbin/daemonsu
    /sbin/busybox rm -f /system/bin/.ext/.su
    /sbin/busybox rm -f /system/etc/install-recovery.sh
    /sbin/busybox rm -f /system/etc/init.d/99SuperSUDaemon
    /sbin/busybox rm -f /system/etc/.installed_su_daemon
    /sbin/busybox rm -f /system/app/Superuser.apk
    /sbin/busybox rm -f /system/app/Superuser.odex
    /sbin/busybox rm -f /system/app/SuperUser.apk
    /sbin/busybox rm -f /system/app/SuperUser.odex
    /sbin/busybox rm -f /system/app/superuser.apk
    /sbin/busybox rm -f /system/app/superuser.odex
    /sbin/busybox rm -f /system/app/Supersu.apk
    /sbin/busybox rm -f /system/app/Supersu.odex
    /sbin/busybox rm -f /system/app/SuperSu.apk
    /sbin/busybox rm -f /system/app/SuperSu.odex
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
    # Placing files
    /sbin/busybox mkdir /system/bin/.ext
    /sbin/busybox cp /res/supersu/su /system/xbin/su
    /sbin/busybox ln -s /res/supersu/su /system/bin/.ext/.su
    /sbin/busybox ln -s /res/supersu/su /system/xbin/daemonsu
    /sbin/busybox cp /res/supersu/Superuser.apk /system/app/Superuser.apk
    /sbin/busybox cp /res/supersu/install-recovery.sh /system/etc/install-recovery.sh
    /sbin/busybox cp /res/supersu/99SuperSUDaemon /system/etc/init.d/99SuperSUDaemon
    /sbin/busybox echo 1 > /system/etc/.installed_su_daemon
    # Setting permissions
    set_perm 0 0 06755 /system/xbin/su
    set_perm 0 0 0777 /system/bin/.ext
    # set_perm 0 0 06755 /system/bin/.ext/.su
    # set_perm 0 0 0755 /system/xbin/daemonsu
    set_perm 0 0 0755 /system/etc/install-recovery.sh
    set_perm 0 0 0755 /system/etc/init.d/99SuperSUDaemon
    set_perm 0 0 0644 /system/etc/.installed_su_daemon
    set_perm 0 0 0644 /system/app/Superuser.apk
    # Setting context
    ch_con /system/xbin/su
    # ch_con /system/bin/.ext/.su
    # ch_con /system/xbin/daemonsu
    ch_con /system/etc/install-recovery.sh
    ch_con /system/etc/init.d/99SuperSUDaemon
    ch_con /system/etc/.installed_su_daemon
    ch_con /system/app/Superuser.apk
    # Post-installation script
    /system/xbin/su --install
fi

# Disable knox stuff
pm disable com.sec.knox.seandroid
pm disable com.sec.knox.eventsmanager
pm disable com.sec.enterprise.knox.attestation
pm disable com.sec.knox.containeragent
pm disable com.sec.knox.app.container
pm disable com.sec.knox.store
pm disable com.samsung.klmsagent
setenforce 0

# Some optimization from Perseus
echo 2 > /sys/devices/system/cpu/sched_mc_power_savings
for i in /sys/block/*/queue/add_random; do
    echo 0 > $i
done
echo 0 > /proc/sys/kernel/randomize_va_space
echo 532 > /sys/devices/platform/pvrsrvkm.0/sgx_dvfs_max_lock
echo 177 > /sys/devices/platform/pvrsrvkm.0/sgx_dvfs_min_lock
echo 50 > /sys/class/devfreq/exynos5-busfreq-mif/polling_interval
echo 70 > /sys/class/devfreq/exynos5-busfreq-mif/time_in_state/upthreshold

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

# Install busybox if not present
if [ ! -f /system/xbin/busybox ]; then
    ln -s /sbin/busybox /system/xbin/busybox
    for i in $(/sbin/busybox --list); do
        if [ ! -f /system/xbin/$i ]; then
            /sbin/busybox ln -s /sbin/busybox /system/xbin/$i
        fi
    done
fi

# STweaks support
chmod -R 755 /res/customconfig/actions
chmod 755 /res/uci.sh
/res/uci.sh apply

rm /data/.maxfour/customconfig.xml
rm /data/.maxfour/action.cache

# Some build.prop optimizations
/system/bin/setprop pm.sleep_mode 1
/system/bin/setprop ro.ril.disable.power.collapse 0
/system/bin/setprop ro.telephony.call_ring.delay 1000

sync

# init.d support
if [ -d /system/etc/init.d ]; then
  /sbin/busybox run-parts /system/etc/init.d
fi

/sbin/busybox mount -t rootfs -o remount,ro rootfs
/sbin/busybox mount -o remount,ro /system
