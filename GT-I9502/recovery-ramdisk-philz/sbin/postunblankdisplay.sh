#!/sbin/sh

echo 0 > /sys/devices/platform/s3c2440-i2c.0/i2c-0/0-0020/input/input1/enabled
echo on > /sys/devices/platform/s3c2440-i2c.0/i2c-0/0-0020/input/input1/power/control
echo 1 > /sys/devices/platform/s3c2440-i2c.0/i2c-0/0-0020/input/input1/enabled

