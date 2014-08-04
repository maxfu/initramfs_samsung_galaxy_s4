#!/system/bin/sh

mount -o remount,rw /system
mount -t rootfs -o remount,rw rootfs

# Set seLinux to Permissive
setenforce 0
 
# Remove knox stuff before everything
if grep -q ro.config.tima=1 /system/build.prop; then
    /sbin/busybox sed -i "s/ro.config.tima=1/ro.config.tima=0/g" /system/build.prop
fi
if grep -q ro.build.selinux=1 /system/build.prop; then
    /sbin/busybox sed -i "s/ro.build.selinux=1/ro.build.selinux=0/g" /system/build.prop
fi
if grep -q ro.config.knox=1 /system/build.prop; then
    /sbin/busybox sed -i "s/ro.config.knox=1/ro.config.knox=0/g" /system/build.prop
fi
rm -rf /system/app/KNOXAgent.apk
rm -rf /system/app/KNOXAgent.odex
rm -rf /system/app/KLMSAgent.apk
rm -rf /system/app/KLMSAgent.odex
rm -rf /system/app/KnoxAttestationAgent.apk
rm -rf /system/app/KnoxAttestationAgent.odex
rm -rf /system/app/KNOXStore.apk
rm -rf /system/app/KNOXStore.odex
rm -rf /system/app/ContainerAgent.apk
rm -rf /system/app/ContainerAgent.odex
rm -rf /system/app/ContainerEventsRelayManager.apk
rm -rf /system/app/ContainerEventsRelayManager.odex
rm -rf /system/app/KNOXStub.apk
rm -rf /system/app/KNOXStub.odex
rm -rf /system/app/KnoxVpnServices.apk
rm -rf /system/app/KnoxVpnServices.odex
rm -rf /system/app/SPDClient.apk
rm -rf /system/app/SPDClient.odex
rm -rf /system/priv-app/KNOXAgent.apk
rm -rf /system/priv-app/KNOXAgent.odex
rm -rf /system/priv-app/KLMSAgent.apk
rm -rf /system/priv-app/KLMSAgent.odex
rm -rf /system/priv-app/KnoxAttestationAgent.apk
rm -rf /system/priv-app/KnoxAttestationAgent.odex
rm -rf /system/priv-app/KNOXStore.apk
rm -rf /system/priv-app/KNOXStore.odex
rm -rf /system/priv-app/ContainerAgent.apk
rm -rf /system/priv-app/ContainerAgent.odex
rm -rf /system/priv-app/ContainerEventsRelayManager.apk
rm -rf /system/priv-app/ContainerEventsRelayManager.odex
rm -rf /system/priv-app/KNOXStub.apk
rm -rf /system/priv-app/KNOXStub.odex
rm -rf /system/priv-app/KnoxVpnServices.apk
rm -rf /system/priv-app/KnoxVpnServices.odex
rm -rf /system/priv-app/SPDClient.apk
rm -rf /system/priv-app/SPDClient.odex
rm -rf /system/lib/libknoxdrawglfunction.so
rm -rf /system/etc/secure_storage/com.sec.knox.store
rm -rf /data/data/com.sec.knox.seandroid
rm -rf /data/data/com.sec.knox.store
rm -rf /data/data/com.sec.knox.containeragent
rm -rf /data/data/com.samsung.android.walletmanager

# Some optimization from Perseus
echo 2 > /sys/devices/system/cpu/sched_mc_power_savings
for i in /sys/block/*/queue/add_random; do
    echo 0 > $i
done
echo 0 > /proc/sys/kernel/randomize_va_space

# Enable I/O Queue Extension
echo 1000 > /proc/sys/vm/dirty_expire_centisecs
echo 500 > /proc/sys/vm/dirty_writeback_centisecs
for node in $(/sbin/busybox find /sys -name nr_requests | grep mmcblk); do echo 1024 > $node; done

mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
