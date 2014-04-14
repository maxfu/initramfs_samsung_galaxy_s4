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
/sbin/busybox echo 2 > /sys/devices/system/cpu/sched_mc_power_savings
for i in /sys/block/*/queue/add_random; do
    /sbin/busybox echo 0 > $i
done
/sbin/busybox echo 0 > /proc/sys/kernel/randomize_va_space
/sbin/busybox echo 50 > /sys/class/devfreq/exynos5-busfreq-mif/polling_interval
/sbin/busybox echo 70 > /sys/class/devfreq/exynos5-busfreq-mif/time_in_state/upthreshold

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
    /sbin/busybox echo "0x0FA4 0x0404 0x0170 0x1DB9 0xF233 0x040B 0x08B6 0x1977 0xF45E 0x040A 0x114C 0x0B43 0xF7FA 0x040A 0x1F97 0xF41A 0x0400 0x1068" > /sys/class/misc/wolfson_control/eq_sp_freqs
    /sbin/busybox echo 11 > /sys/class/misc/wolfson_control/eq_sp_gain_1
    /sbin/busybox echo -7 > /sys/class/misc/wolfson_control/eq_sp_gain_2
    /sbin/busybox echo 4 > /sys/class/misc/wolfson_control/eq_sp_gain_3
    /sbin/busybox echo -10 > /sys/class/misc/wolfson_control/eq_sp_gain_4
    /sbin/busybox echo -0 > /sys/class/misc/wolfson_control/eq_sp_gain_5
    /sbin/busybox echo 1 > /sys/class/misc/wolfson_control/switch_eq_speaker
fi

# Install busybox if not present
if [ ! -f /system/xbin/busybox ]; then
    /sbin/busybox ln -s /sbin/busybox /system/xbin/busybox
    for i in $(/sbin/busybox --list); do
        if [ ! -f /system/xbin/$i ]; then
            /sbin/busybox ln -s /sbin/busybox /system/xbin/$i
        fi
    done
fi

# STweaks support
/sbin/busybox chmod -R 755 /res/customconfig/actions
/sbin/busybox chmod 755 /res/uci.sh
/res/uci.sh apply

/sbin/busybox rm /data/.maxfour/customconfig.xml
/sbin/busybox rm /data/.maxfour/action.cache

# Some build.prop optimizations
/system/bin/setprop pm.sleep_mode 1
/system/bin/setprop ro.ril.disable.power.collapse 0
/system/bin/setprop ro.telephony.call_ring.delay 1000

# Workaround on siop currents which by default is too high
/sbin/busybox echo 1200 > /sys/devices/platform/sec-battery/siop_input_limit
/sbin/busybox echo 1000 > /sys/devices/platform/sec-battery/siop_charge_limit

# Apply fstrim on some partitions
/sbin/fstrim -v /system
/sbin/fstrim -v /data
/sbin/fstrim -v /cache

# Apply normal usage oom settings
/sbin/busybox echo "1024,2048,4096,8192,12288,16384" > /sys/module/lowmemorykiller/parameters/minfree

# Apply sysctl optimizations (testing)
/sbin/busybox sysctl -w fs.inotify.max_user_instances=256
/sbin/busybox sysctl -w fs.inotify.max_queued_events=32000
/sbin/busybox sysctl -w vm.vfs_cache_pressure=10
/sbin/busybox sysctl -w kernel.panic=10
/sbin/busybox sysctl -w kernel.msgmax=65536
/sbin/busybox sysctl -w fs.file-max=524288
/sbin/busybox sysctl -w vm.page-cluster=3
/sbin/busybox sysctl -w net.core.wmem_max=524288
/sbin/busybox sysctl -w kernel.sem='500 512000 64 2048'
/sbin/busybox sysctl -w net.core.rmem_max=524288
/sbin/busybox sysctl -w vm.min_free_kbytes=4096
/sbin/busybox sysctl -w vm.drop_caches=3
/sbin/busybox sysctl -w net.ipv4.tcp_rmem='6144 87380 524288'
/sbin/busybox sysctl -w fs.lease-break-time=10
/sbin/busybox sysctl -w kernel.threads-max=524288
/sbin/busybox sysctl -w kernel.sched_wakeup_granularity_ns=3000000
/sbin/busybox sysctl -w net.ipv4.tcp_wmem='6144 87380 524288'
/sbin/busybox sysctl -w vm.dirty_ratio=90
/sbin/busybox sysctl -w kernel.shmmax=268435456
/sbin/busybox sysctl -w kernel.sched_min_granularity_ns=1500000
/sbin/busybox sysctl -w kernel.sched_latency_ns=18000000
/sbin/busybox sysctl -w vm.dirty_expire_centisecs=250
/sbin/busybox sysctl -w kernel.msgmni=2048
/sbin/busybox sysctl -w fs.inotify.max_user_watches=10240
/sbin/busybox sysctl -w vm.dirty_background_ratio=70
/sbin/busybox sysctl -w net.ipv4.tcp_tw_recycle=1

sync

# init.d support
if [ -d /system/etc/init.d ]; then
  /sbin/busybox run-parts /system/etc/init.d
fi

/sbin/busybox mount -t rootfs -o remount,ro rootfs
/sbin/busybox mount -o remount,ro /system
