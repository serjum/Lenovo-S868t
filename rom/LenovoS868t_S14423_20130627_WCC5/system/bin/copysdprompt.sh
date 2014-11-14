#!/system/bin/sh
export PATH=/system/bin:$PATH
busybox sh /system/bin/am start -n 		com.android.settings/.FactoryInstallAppsDialog
