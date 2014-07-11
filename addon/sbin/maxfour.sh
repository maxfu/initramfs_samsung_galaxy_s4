#!/sbin/busybox sh
# MaxFour kernel script (Root helper by Wanam)
# Used to be adam.sh by Wanam
# Modified by MaxFu

# Pre-defined functions
set_perm() {
    /sbin/busybox chown $1.$2 $4
    /sbin/busybox chown $1:$2 $4
    /sbin/busybox chmod $3 $4
}

ch_con() {
	/system/bin/toolbox chcon u:object_r:system_file:s0 $1
	chcon u:object_r:system_file:s0 $1
}

# Start post-init script
/sbin/busybox mount -o remount,rw /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs

# Set seLinux to Permissive
setenforce 0
 
# Remove knox stuff before everything
if /sbin/busybox grep -q ro.config.tima=1 /system/build.prop; then
    /sbin/busybox sed -i "s/ro.config.tima=1/ro.config.tima=0/g" /system/build.prop
fi
if /sbin/busybox grep -q ro.build.selinux=1 /system/build.prop; then
    /sbin/busybox sed -i "s/ro.build.selinux=1/ro.build.selinux=0/g" /system/build.prop
fi
if /sbin/busybox grep -q ro.config.knox=1 /system/build.prop; then
    /sbin/busybox sed -i "s/ro.config.knox=1/ro.config.knox=0/g" /system/build.prop
fi
/sbin/busybox rm -rf /system/app/KNOXAgent.apk
/sbin/busybox rm -rf /system/app/KNOXAgent.odex
/sbin/busybox rm -rf /system/app/KLMSAgent.apk
/sbin/busybox rm -rf /system/app/KLMSAgent.odex
/sbin/busybox rm -rf /system/app/KnoxAttestationAgent.apk
/sbin/busybox rm -rf /system/app/KnoxAttestationAgent.odex
/sbin/busybox rm -rf /system/app/KNOXStore.apk
/sbin/busybox rm -rf /system/app/KNOXStore.odex
/sbin/busybox rm -rf /system/app/ContainerAgent.apk
/sbin/busybox rm -rf /system/app/ContainerAgent.odex
/sbin/busybox rm -rf /system/app/ContainerEventsRelayManager.apk
/sbin/busybox rm -rf /system/app/ContainerEventsRelayManager.odex
/sbin/busybox rm -rf /system/app/KNOXStub.apk
/sbin/busybox rm -rf /system/app/KNOXStub.odex
/sbin/busybox rm -rf /system/app/KnoxVpnServices.apk
/sbin/busybox rm -rf /system/app/KnoxVpnServices.odex
/sbin/busybox rm -rf /system/app/SPDClient.apk
/sbin/busybox rm -rf /system/app/SPDClient.odex
/sbin/busybox rm -rf /system/priv-app/KNOXAgent.apk
/sbin/busybox rm -rf /system/priv-app/KNOXAgent.odex
/sbin/busybox rm -rf /system/priv-app/KLMSAgent.apk
/sbin/busybox rm -rf /system/priv-app/KLMSAgent.odex
/sbin/busybox rm -rf /system/priv-app/KnoxAttestationAgent.apk
/sbin/busybox rm -rf /system/priv-app/KnoxAttestationAgent.odex
/sbin/busybox rm -rf /system/priv-app/KNOXStore.apk
/sbin/busybox rm -rf /system/priv-app/KNOXStore.odex
/sbin/busybox rm -rf /system/priv-app/ContainerAgent.apk
/sbin/busybox rm -rf /system/priv-app/ContainerAgent.odex
/sbin/busybox rm -rf /system/priv-app/ContainerEventsRelayManager.apk
/sbin/busybox rm -rf /system/priv-app/ContainerEventsRelayManager.odex
/sbin/busybox rm -rf /system/priv-app/KNOXStub.apk
/sbin/busybox rm -rf /system/priv-app/KNOXStub.odex
/sbin/busybox rm -rf /system/priv-app/KnoxVpnServices.apk
/sbin/busybox rm -rf /system/priv-app/KnoxVpnServices.odex
/sbin/busybox rm -rf /system/priv-app/SPDClient.apk
/sbin/busybox rm -rf /system/priv-app/SPDClient.odex
/sbin/busybox rm -rf /system/lib/libknoxdrawglfunction.so
/sbin/busybox rm -rf /system/etc/secure_storage/com.sec.knox.store
/sbin/busybox rm -rf /data/data/com.sec.knox.seandroid
/sbin/busybox rm -rf /data/data/com.sec.knox.store
/sbin/busybox rm -rf /data/data/com.sec.knox.containeragent
/sbin/busybox rm -rf /data/data/com.samsung.android.walletmanager

# Auto-Root, only install when /system/xbin/su is missing
if [ ! -f /system/xbin/su ] && [ -d /res/supersu/ ]; then
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
# Placing files"
/sbin/busybox mkdir /system/bin/.ext
/sbin/busybox cp /res/supersu/su /system/xbin/su
/sbin/busybox cp /res/supersu/su /system/xbin/daemonsu
/sbin/busybox cp /res/supersu/su /system/bin/.ext/.su
/sbin/busybox cp /res/supersu/Superuser.apk /system/app/Superuser.apk
/sbin/busybox cp /res/supersu/install-recovery.sh /system/etc/install-recovery.sh
/sbin/busybox cp /res/supersu/99SuperSUDaemon /system/etc/init.d/99SuperSUDaemon
/sbin/busybox echo 1 > /system/etc/.installed_su_daemon
/sbin/busybox ln -s /system/xbin/su /system/bin/su
# Setting permissions
set_perm 0 0 0777 /system/bin/.ext
set_perm 0 0 06755 /system/bin/.ext/.su
set_perm 0 0 06755 /system/xbin/su
set_perm 0 0 0755 /system/xbin/daemonsu
set_perm 0 0 0755 /system/etc/install-recovery.sh
set_perm 0 0 0755 /system/etc/init.d/99SuperSUDaemon
set_perm 0 0 0644 /system/etc/.installed_su_daemon
set_perm 0 0 0644 /system/app/Superuser.apk
# Setting context
ch_con /system/bin/.ext/.su
ch_con /system/xbin/su
ch_con /system/xbin/daemonsu
ch_con /system/etc/install-recovery.sh
ch_con /system/etc/init.d/99SuperSUDaemon
ch_con /system/etc/.installed_su_daemon
ch_con /system/app/Superuser.apk
# Post-installation script
/system/xbin/su --install
fi

# Install busybox if not present
if [ ! -f /system/xbin/busybox ]; then
    /sbin/busybox cp -a /sbin/busybox /system/xbin/busybox
    /system/xbin/busybox --install -s /system/xbin
fi

# Some optimization from Perseus
# /sbin/busybox echo 2 > /sys/devices/system/cpu/sched_mc_power_savings
# for i in /sys/block/*/queue/add_random; do
#     /sbin/busybox echo 0 > $i
# done
# /sbin/busybox echo 0 > /proc/sys/kernel/randomize_va_space

# Enable Entropy Generator
# /sbin/rngd -P -T 1 -s 1024 -t 0.25 -W 90
# /sbin/busybox echo -16 > /proc/$(/sbin/busybox pgrep rngd)/oom_adj
# /sbin/busybox renice 5 $(/sbin/busybox pgrep rngd)

# Enable I/O Queue Extension
# /sbin/busybox echo 1000 > /proc/sys/vm/dirty_expire_centisecs
# /sbin/busybox echo 500 > /proc/sys/vm/dirty_writeback_centisecs
# for node in $(/sbin/busybox find /sys -name nr_requests | /sbin/busybox grep mmcblk); do /sbin/busybox echo 1024 > $node; done

# Pre-config wolfson sound control if on GT-I9500
if [ -d /sys/class/misc/wolfson_control ]; then
    /sbin/busybox echo "0x0FA4 0x0404 0x0170 0x1DB9 0xF233 0x040B 0x08B6 0x1977 0xF45E 0x040A 0x114C 0x0B43 0xF7FA 0x040A 0x1F97 0xF41A 0x0400 0x1068" > /sys/class/misc/wolfson_control/eq_sp_freqs
    /sbin/busybox echo 11 > /sys/class/misc/wolfson_control/eq_sp_gain_1
    /sbin/busybox echo -7 > /sys/class/misc/wolfson_control/eq_sp_gain_2
    /sbin/busybox echo 4 > /sys/class/misc/wolfson_control/eq_sp_gain_3
    /sbin/busybox echo -10 > /sys/class/misc/wolfson_control/eq_sp_gain_4
    /sbin/busybox echo -0 > /sys/class/misc/wolfson_control/eq_sp_gain_5
    /sbin/busybox echo 1 > /sys/class/misc/wolfson_control/switch_eq_speaker
fi

# STweaks support
/sbin/busybox chmod -R 755 /res/customconfig/actions
/sbin/busybox chmod 755 /res/uci.sh
/res/uci.sh apply
/sbin/busybox rm /data/.maxfour/customconfig.xml
/sbin/busybox rm /data/.maxfour/action.cache

# init.d support
if [ ! -d /system/etc/init.d ]; then
  /sbin/busybox mkdir /system/etc/init.d
fi
/sbin/busybox cp /res/initd/* /system/etc/init.d
/sbin/busybox chmod -R 0755 /system/etc/init.d
/sbin/busybox run-parts /system/etc/init.d

# Sync
sync

/sbin/busybox mount -t rootfs -o remount,ro rootfs
/sbin/busybox mount -o remount,ro /system
