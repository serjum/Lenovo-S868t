#!/system/bin/sh


ifconfig wlan0 down
echo /etc/wifi/sdio-g-mfgtest.bin > /sys/module/bcmdhd/parameters/firmware_path
ifconfig wlan0 up


CHANNEL=$(getprop net.wifi.adbtest.channel)

wl down
wl mpc 0
wl country ALL
wl PM 0
wl up
wl out
wl fqacurcy $CHANNEL


