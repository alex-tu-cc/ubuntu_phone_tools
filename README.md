# ubuntu_phone_tools

## repack-factory-img/arale
A tool to repack flashable factory images from released tarballs.
ex. ./mkflashable.sh --autobuild --channel ubuntu-touch/rc-proposed/meizu.en

## repack-factory-img/turbo
The images could be flased by fastboot as factory images.
The way to flash images could refer to flash_all_bootloader_ubuntu.sh
The way to repack images:
ex. ./mkflashable.sh --autobuild --channel ubuntu-touch/rc-proposed/meizu.en

 *NOTICE* :
Flash your device by flash tool might brick your device.
Please aware the risk and have backup solution.
Author will not be responsable to anything happens to your device by this tool.

## adb_pull_logs.sh
A small script to get logcat, /var/log/*, /home/phablet/.cache/upstart/*
    This script assume your password on device is '1111' (you an change it in source code).
    Then get logcat to logcat.log in background.
    In the mean while, you can try to reproduce the issue,
    Then press anykey to let script continue to get all logs
