#!/sbin/busybox sh
# Reading Settings with fault-tolerance
if [ -f /system/nirvana.prop ]; then
    ROM_TYPE=$(/sbin/busybox grep ro\.romtype /system/nirvana.prop | /sbin/busybox cut -d'=' -f2)
    CPU_MAX=$(/sbin/busybox grep ro\.cpumax /system/nirvana.prop | /sbin/busybox cut -d'=' -f2)
    CPU_MIN=$(/sbin/busybox grep ro\.cpumin /system/nirvana.prop | /sbin/busybox cut -d'=' -f2)
    CPU_GOV=$(/sbin/busybox grep ro\.cpugov /system/nirvana.prop | /sbin/busybox cut -d'=' -f2)
    IO_SCHED=$(/sbin/busybox grep ro\.iosched /system/nirvana.prop | /sbin/busybox cut -d'=' -f2)
    LOGCAT=$(/sbin/busybox grep ro\.logcat /system/nirvana.prop | /sbin/busybox cut -d'=' -f2)
    ZRAM=$(/sbin/busybox grep ro\.zram /system/nirvana.prop | /sbin/busybox cut -d'=' -f2)
    J4FS=$(/sbin/busybox grep ro\.j4fs /system/nirvana.prop | /sbin/busybox cut -d'=' -f2)
    CIFS=$(/sbin/busybox grep ro\.cifs /system/nirvana.prop | /sbin/busybox cut -d'=' -f2)
    SEEDER=$(/sbin/busybox grep ro\.seeder /system/nirvana.prop | /sbin/busybox cut -d'=' -f2)
else
    ROM_TYPE="automatic"
    CPU_MAX="1400000"
    CPU_MIN="200000"
    CPU_GOV="ondemand"
    IO_SCHED="noop"
    LOGCAT="disable"
    ZRAM="disable"
    J4FS="disable"
    CIFS="disable"
    SEEDER="enable"
fi

# Logging
/sbin/busybox cp /data/user.log /data/user.log.bak
/sbin/busybox rm /data/user.log
exec >>/data/user.log
exec 2>&1

# Remount rootfs rw
  #/sbin/busybox mount rootfs -o remount,rw

##### Early-init phase #####
# IPv6 privacy tweak
#if /sbin/busybox [ "`/sbin/busybox grep IPV6PRIVACY /system/etc/tweaks.conf`" ]; then
    echo "2" > /proc/sys/net/ipv6/conf/all/use_tempaddr
#fi

# Remount all partitions with noatime
for k in $(/sbin/busybox mount | /sbin/busybox grep relatime | /sbin/busybox cut -d " " -f3)
do
    sync
    /sbin/busybox mount -o remount,noatime $k
done

# Remount ext4 partitions with optimizations
for k in $(/sbin/busybox mount | /sbin/busybox grep ext4 | /sbin/busybox cut -d " " -f3)
do
    sync
    /sbin/busybox mount -o remount,commit=15 $k
done
  
# Miscellaneous tweaks
/sbin/busybox echo "1500" > /proc/sys/vm/dirty_writeback_centisecs
/sbin/busybox echo "200" > /proc/sys/vm/dirty_expire_centisecs
/sbin/busybox echo "0" > /proc/sys/vm/swappiness
/sbin/busybox echo "8192" > /proc/sys/vm/min_free_kbytes

# CFS scheduler tweaks
/sbin/busybox echo HRTICK > /sys/kernel/debug/sched_features

# TCP tweaks
/sbin/busybox echo "2" > /proc/sys/net/ipv4/tcp_syn_retries
/sbin/busybox echo "2" > /proc/sys/net/ipv4/tcp_synack_retries
/sbin/busybox echo "10" > /proc/sys/net/ipv4/tcp_fin_timeout

# SCHED_MC power savings level
# echo "1" > /sys/devices/system/cpu/sched_mc_power_savings

# Turn off debugging for certain modules
/sbin/busybox echo "0" > /sys/module/wakelock/parameters/debug_mask
/sbin/busybox echo "0" > /sys/module/userwakelock/parameters/debug_mask
/sbin/busybox echo "0" > /sys/module/earlysuspend/parameters/debug_mask
/sbin/busybox echo "0" > /sys/module/alarm/parameters/debug_mask
/sbin/busybox echo "0" > /sys/module/alarm_dev/parameters/debug_mask
/sbin/busybox echo "0" > /sys/module/binder/parameters/debug_mask

##### Install SU #####
# Check for auto-root bypass config file
if [ -f /system/.noautoroot ] || [ -f /data/.noautoroot ];
then
    /sbin/busybox echo "File .noautoroot found. Auto-root will be bypassed."
else
    # Start of auto-root section
    # Check the SU binary
    # MaxFu: bypassed Supersu.apk detection for some ROM with different file name.
    if [ -f /system/bin/su ] || [ -f /system/xbin/su ]; then
        break
    else
        /sbin/busybox mount /system -o remount,rw
        /sbin/busybox rm /data/app/Superuser.apk
		/sbin/busybox rm /data/app/SuperuserElite.apk
		/sbin/busybox rm /data/app/SuperUser.apk
		/sbin/busybox rm /data/app/SuperSU.apk
		/sbin/busybox rm /data/app/SuperSUPro.apk
        /sbin/busybox rm /system/app/Superuser.apk
		/sbin/busybox rm /system/app/SuperuserElite.apk
		/sbin/busybox rm /system/app/SuperUser.apk
		/sbin/busybox rm /system/app/SuperSU.apk
		/sbin/busybox rm /system/app/SuperSUPro.apk
        /sbin/busybox rm /system/bin/su
        /sbin/busybox rm /system/xbin/su
        /sbin/busybox cp /res/misc/supersu/su /system/bin/su
        /sbin/busybox cp /res/misc/supersu/Superuser.apk /system/app/Superuser.apk
        /sbin/busybox chown 0.0 /system/app/Superuser.apk
        /sbin/busybox chown 0.0 /system/bin/su
        /sbin/busybox chmod 644 /system/app/Superuser.apk
        /sbin/busybox chmod 6755 /system/bin/su
		/sbin/busybox /system/bin/su /system/xbin/su
        /sbin/busybox mount /system -o remount,ro
    fi
fi

##### Fix freeze on FC problem #####

# Zero dumpstate files
cat /dev/null > /data/log/dumpstate_app_error.txt.gz.tmp
cat /dev/null > /data/log/dumpstate_app_native.txt.gz.tmp
cat /dev/null > /data/log/dumpstate_sys_watchdog.txt.gz.tmp
cat /dev/null > /data/log/dumpstate_app_anr.txt.gz.tmp
cat /dev/null > /data/log/dumpstate_app_error.txt.gz
# Change permissions to read-only for key dumpstate files
chmod 400 /data/log/dumpstate_app_error.txt.gz.tmp
chmod 400 /data/log/dumpstate_app_native.txt.gz.tmp
chmod 400 /data/log/dumpstate_sys_watchdog.txt.gz.tmp
chmod 400 /data/log/dumpstate_app_anr.txt.gz.tmp
chmod 400 /data/log/dumpstate_app_error.txt.gz
# End of dumpstate cleanup

# Cleanup busybox
  #/sbin/busybox rm /sbin/busybox
  #/sbin/busybox mount rootfs -o remount,ro

# Android Logger enable tweak
if [ "$LOGCAT" = 'enable' ]; then
    insmod /lib/modules/logger.ko
fi

# Android Logger enable tweak
if [ "$J4FS" = 'disable' ]; then
    umount /mnt/.lfs
    rmmod j4fs
fi

# Android Logger enable tweak
if [ "$CIFS" = 'enable' ]; then
    insmod /lib/modules/cifs.ko
fi

# CPU Frequencies, Governor and IO Scheduler settings
# Applying CPU maximum frequency setting with fault-tolerance
if [ "$CPU_MAX" = '1600000' ] || [ "$CPU_MAX" = '1200000' ] || [ "$CPU_MAX" = '1000000' ] || [ "$CPU_MAX" = '800000' ]; then
    /sbin/busybox echo $CPU_MAX >> /system/version.prop
    /sbin/busybox echo $CPU_MAX > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
else
    /sbin/busybox echo '1400000' >> /system/version.prop
    /sbin/busybox echo '1400000' > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
fi

# Applying CPU minimum frequency setting with fault-tolerance
if [ "$CPU_MIN" = '800000' ] || [ "$CPU_MIN" = '500000' ] || [ "$CPU_MIN" = '100000' ]; then
    /sbin/busybox echo $CPU_MIN >> /system/version.prop
    /sbin/busybox echo $CPU_MIN > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
else
    /sbin/busybox echo "200000" >> /system/version.prop
    /sbin/busybox echo "200000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
fi

# Applying CPU governor setting with fault-tolerance
if [ "$CPU_GOV" = 'ondemand' ] || [ "$CPU_GOV" = 'adaptive' ] || [ "$CPU_GOV" = 'interactive' ] || [ "$CPU_GOV" = 'conservative' ] || [ "$CPU_GOV" = 'powersave' ] || [ "$CPU_GOV" = 'performance' ]; then
    /sbin/busybox echo $CPU_GOV >> /system/version.prop
    /sbin/busybox echo $CPU_GOV > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
else
    /sbin/busybox echo "pegasusq" >> /system/version.prop
    /sbin/busybox echo "pegasusq" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
fi

# Applying I/O scheduler setting with fault-tolerance
if [ "$IO_SCHED" = 'zen' ] || [ "$IO_SCHED" = 'row' ] || [ "$IO_SCHED" = 'vr' ] || [ "$IO_SCHED" = 'deadline' ] || [ "$IO_SCHED" = 'noop' ] || [ "$IO_SCHED" = 'sio' ]; then
    /sbin/busybox echo $IO_SCHED >> /system/version.prop
    for i in $(/sbin/busybox find /sys/block/mmc*)
    do
        /sbin/busybox echo $IO_SCHED > $i/queue/scheduler
    done
else
    /sbin/busybox echo "cfq" >> /system/version.prop
    for i in $(/sbin/busybox find /sys/block/mmc*)
    do
        /sbin/busybox echo "cfq" > $i/queue/scheduler
        # Tweak cfq io scheduler
        /sbin/busybox echo "0" > $i/queue/rotational
        /sbin/busybox echo "0" > $i/queue/iostats
        /sbin/busybox echo "8" > $i/queue/iosched/quantum
        /sbin/busybox echo "4" > $i/queue/iosched/slice_async_rq
        /sbin/busybox echo "1" > $i/queue/iosched/low_latency
        /sbin/busybox echo "0" > $i/queue/iosched/slice_idle
        /sbin/busybox echo "1" > $i/queue/iosched/back_seek_penalty
        /sbin/busybox echo "1000000000" > $i/queue/iosched/back_seek_max
    done
fi

# ZRam and Swap tweak
if [ "$ZRAM" = 'enable' ]; then
    /sbin/busybox echo ZRAM >> /system/version.prop
    /sbin/busybox insmod /lib/modules/lzo_compress.ko
    /sbin/busybox insmod /lib/modules/lzo_decompress.ko
    /sbin/busybox insmod /lib/modules/zram.ko
    echo '1' > /sys/block/zram0/reset
    echo $((128*1024*1024)) > /sys/block/zram0/disksize
    /sbin/busybox mkswap /dev/block/zram0
    /sbin/busybox swapon /dev/block/zram0
    /sbin/busybox sysctl -w vm.swappiness=60
fi

# Seeder entropy generator
if [ "$SEEDER" = 'enable' ]; then
    /sbin/busybox echo SEEDER >> /system/version.prop
    /sbin/rngd --feed-interval=0.25 --rng-timeout=1 --random-step=1024 --fill-watermark=90%
    /sbin/busybox sleep 2
    /sbin/busybox echo -8 > /proc/$(/sbin/busybox pgrep rngd)/oom_adj
    /sbin/busybox renice 5 $(/sbin/busybox pidof rngd)
    /sbin/busybox echo 1000 > /proc/sys/vm/dirty_expire_centisecs
    /sbin/busybox echo 500 > /proc/sys/vm/dirty_writeback_centisecs
    for node in $(/sbin/busybox find /sys -name nr_requests | /sbin/busybox grep mmcblk); do
        /sbin/busybox echo 1024 > $node
    done
fi

# init.d support
if [ -d /system/etc/init.d ]; then  
    /sbin/busybox run-parts /system/etc/init.d
fi

if [ -d /data/init.d ]; then  
    /sbin/busybox run-parts /data/init.d
fi
