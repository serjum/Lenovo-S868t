#!/system/bin/sh

ifconfig wlan0 down
echo /etc/wifi/sdio-g-mfgtest.bin > /sys/module/bcmdhd/parameters/firmware_path
ifconfig wlan0 up

wl pkteng_stop rx 
wl pkteng_stop tx


