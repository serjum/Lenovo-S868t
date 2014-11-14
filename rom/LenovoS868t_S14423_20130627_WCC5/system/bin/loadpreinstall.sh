#!/system/bin/sh
export PATH=/system/bin:$PATH
PRELOAD_APP_DIR=/system/preinstall/app
PRELOAD_HASH_DIR=/system/preinstall/flag
DATA_HASH_DIR=/data/preinstall_flag
PRELOAD_DONE_PROP=sys.preinstall.done
#PRELOAD_LOG_FILE=$DATA_HASH_DIR/log.txt


FACTORY_FLAG=$(getprop ro.factorytest)

if [ $FACTORY_FLAG -ne 3 ]; then
     echo "normal mode"
else
     echo "factory mode"
     exit 0
fi

# wake
echo preinstall > /sys/power/wake_lock

umask 003

mkdir $DATA_HASH_DIR

for file in `ls $PRELOAD_APP_DIR`; do
    echo "$file: comparing $PRELOAD_HASH_DIR/$file.flag and $DATA_HASH_DIR/$file.flag"
#    echo "$file: comparing $PRELOAD_HASH_DIR/$file.flag and $DATA_HASH_DIR/$file.flag" >> $PRELOAD_LOG_FILE
    newflag=`cat $PRELOAD_HASH_DIR/$file.flag`
    oldflag=`cat $DATA_HASH_DIR/$file.flag`
    if [ "$newflag" != "$oldflag" ]; then
        isInstalled=`busybox sh /system/bin/pm path $file`
        if [ -n "$isInstalled" -o ! -e "$DATA_HASH_DIR/$file.flag" ]; then
            busybox sh /system/bin/pm install -r $PRELOAD_APP_DIR/$file
            ret=$?
            if [ $ret -ne 0 ]; then
                echo "$file: install failed, error: $ret"
#               echo "$file: install failed, error: $ret" >> $PRELOAD_LOG_FILE
            else
                echo "$file: install successful, copying $file.flag to $DATA_HASH_DIR"
#               echo "$file: install successful, copying $file.flag to $DATA_HASH_DIR" >> $PRELOAD_LOG_FILE
                busybox cp $PRELOAD_HASH_DIR/$file.flag $DATA_HASH_DIR
            fi
        else
            echo "$file: user has uninstalled, dont reinstall. copying $file.flag to $DATA_HASH_DIR"
#           echo "$file: user has uninstalled, dont reinstall. copying $file.flag to $DATA_HASH_DIR" >> $PRELOAD_LOG_FILE
            busybox cp $PRELOAD_HASH_DIR/$file.flag $DATA_HASH_DIR
        fi
    else
        echo "$file: install skipped, file unchanged"
#        echo "$file: install skipped, file unchanged" >> $PRELOAD_LOG_FILE
    fi
done

retries=10
echo "preinstall finished, setting $PRELOAD_DONE_PROP to 1"
#echo "preinstall finished, setting $PRELOAD_DONE_PROP to 1" >> $PRELOAD_LOG_FILE
setprop $PRELOAD_DONE_PROP 1
readback=`getprop $PRELOAD_DONE_PROP`
while [ "$readback" != "1" -a $retries -gt 0 ]
do
    echo "  property readback failed! expected 1, got $readback. retries left $retries..."
#    echo "  property readback failed! expected 1, got $readback. retries left $retries..." >> $PRELOAD_LOG_FILE
    retries=$(($retries-1))
    sleep 2
    setprop $PRELOAD_DONE_PROP 1
    readback=`getprop $PRELOAD_DONE_PROP`
done

# sleep
echo preinstall > /sys/power/wake_unlock
echo "preinstall exiting..."
#echo "preinstall exiting..." >> $PRELOAD_LOG_FILE
