#!/system/bin/sh

setprop persist.sys.sdcard.copy 0

busybox mkdir /mnt/sdcard/.install/
busybox tar -xvf /system/preinstall/lenovo/lenovores.tar -C /mnt/sdcard/.install/
busybox sync
busybox mv /mnt/sdcard/.install/lenovo  /mnt/sdcard/lenovo
busybox rm -rf mnt/sdcard/.install
busybox sync
setprop persist.sys.sdcard.copy 1


