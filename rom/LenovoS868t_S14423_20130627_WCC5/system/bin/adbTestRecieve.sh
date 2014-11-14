#!/system/bin/sh

ifconfig wlan0 down
echo /etc/wifi/sdio-g-mfgtest.bin > /sys/module/bcmdhd/parameters/firmware_path
ifconfig wlan0 up


CHANNEL=$(getprop net.wifi.adbtest.channel)
RATE=$(getprop net.wifi.adbtest.rate)


wl disassoc
wl mpc 0
wl down
wl channel $CHANNEL
wl bi 50000
wl join test imode adhoc
wl rate $RATE
#wl rateset 11b
wl scansuppress 1
wl up
wl counters


