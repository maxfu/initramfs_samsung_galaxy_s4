#!/system/bin/sh

if [ -d /system/etc/init.d ]; then
  for i in /system/etc/init.d/*; do
    /system/bin/sh $i
  done
fi

