#!/system/bin/sh

setprop ontim.backupunzip_result 0

APP_TARNAME=$(getprop ontim.backupunzip_tarname)
APP_ID=$(getprop ontim.backupunzip_id)
APP_NAME=$(getprop ontim.backupunzip_name)

echo "$APP_TARNAME"
echo "$APP_ID"
echo "$APP_NAME"

busybox tar -xvf /mnt/sdcard/external_sdcard/backup/App/$APP_TARNAME
busybox chown -R app_$APP_ID.app_$APP_ID /data/data/$APP_NAME
busybox chown -R system.system /data/data/$APP_NAME/lib

setprop ontim.backupunzip_result 1

