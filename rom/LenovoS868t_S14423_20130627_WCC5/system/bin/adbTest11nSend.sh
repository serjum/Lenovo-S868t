#!/system/bin/sh

ifconfig wlan0 down
echo /etc/wifi/sdio-g-mfgtest.bin > /sys/module/bcmdhd/parameters/firmware_path
ifconfig wlan0 up

CHANNEL=$(getprop net.wifi.adbtest.channel)
POWER=$(getprop net.wifi.adbtest.power)

wl down
wl mpc 0
wl country ALL
wl PM 0
wl channel $CHANNEL
wl nrate -m 7
wl rate
wl up
wl txpwr1 -o -d $POWER
wl scansuppress 1
wl pkteng_start 00:90:4C:C5:00:D8 tx 100 1024 0



