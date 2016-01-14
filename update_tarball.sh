#!/bin/bash
wait_recovery(){
    while [ 1 ];
    do
        echo wait recovery...
        sleep 1
        adb devices | grep recovery || continue
        break
    done
}
echo please update tarball in recovery mode.
wait_recovery
[ -e $1 ] || { echo "$1 not exist"; exit; }
echo pushing $1
adb push $1 /cache/recovery/
adb shell rm -f /cache/recovery/ubuntu_command
adb shell "echo mount system >> /cache/recovery/ubuntu_command"
adb shell "echo update $1 >> /cache/recovery/ubuntu_command"
adb shell "echo umount system >> /cache/recovery/ubuntu_command"
# skip signature checking:
adb shell mkdir -p /etc/system-image
adb shell touch /etc/system-image/skip-gpg-verification
# reboot to recovery and wait upgrader done.
adb reboot recovery
wait_recovery
while [ 1 ]; do
[ -n "$(adb shell ls /cache/recovery/$1 | grep No)" ] && break
echo wait upgrader...
sleep 3
done
echo "updated $1, reboot device"
sleep 2
adb reboot 
