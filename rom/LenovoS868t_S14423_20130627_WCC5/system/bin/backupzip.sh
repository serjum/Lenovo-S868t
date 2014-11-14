#!/system/bin/sh

setprop ontim.backupzip_result 0

APP_NAME=$(getprop ontim.backupzip_name)
APP_DIR=$(getprop ontim.backupzip_backdir)
echo "$APP_NAME"
echo "$APP_DIR"
busybox tar -cvf /mnt/sdcard/external_sdcard/backup/App/$APP_NAME.tar $APP_DIR
busybox sync

setprop ontim.backupzip_result 1

