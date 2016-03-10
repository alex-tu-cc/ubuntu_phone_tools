#!/bin/bash
set -e
set -x 
password="1111"
usage() {
echo << EOF
        A small script to get logcat, /var/log/*, /home/phablet/.cache/upstart/*
        usage: $(basename $0)
            This script assume your password on device is '1111'.
            Then get logcat to logcat.log in background.
            In the mean while, you can try to reproduce the issue,
            Then press anykey to let script continue to get all logs
EOF
}

while [ $# -gt 0 ]
do
    case "$1" in
        -h | --help)
            usage 0
            ;;
        -p | --password)
            echo "password=$2"
            password=$2
            ;;
        -c | --clean)
            CLEAN=true
            ;;
        *)
       esac
       shift
done

logs=`mktemp -d backup.XXXXX`
pushd $logs
# get logcat
adb shell '/bin/echo -e "#!/bin/sh\necho 1111" >/tmp/askpass'
adb shell "chmod +x /tmp/askpass"
[ CLEAN == "true" ] && adb shell "SUDO_ASKPASS=/tmp/askpass sudo -A /system/bin/logcat -c"
adb shell "SUDO_ASKPASS=/tmp/askpass sudo -A /system/bin/logcat" > logcat.log &
PID=$! 
echo "getting logcat into logcat.log ...."
echo "press anykey to stop logcat and get logs under /var/log and ~/.cache/upstart ..... "
read
adb pull /var/log
adb pull /home/phablet/.cache/upstart
kill $PID
echo "All logs are in $logs"
