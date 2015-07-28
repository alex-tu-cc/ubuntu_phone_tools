#!/bin/bash

TMP_FLODER=`mktemp -d --tmpdir=$PWD --suffix=_merge_phablet_$(date +%s)`
usage(){
cat<< EOF
    This is usage()
EOF
}

merge(){
 local path=$1
 local name=$2
 local revision=$3
 local PHABLET_ADDR="ssh://code-review.phablet.ubuntu.com:29418/"
 local remote=ondra-a5
 local log_file=$TMP_FLODER/phablet_merge.log
 local not_exist_folder=$TMP_FLODER/not_exist_folder.log

 revision=`echo "$revision" | sed 's/refs\/heads/remote/'`
cat<< EOF
 $path $name $revision
 if [ -d $path ]; then
     pushd $path
     git add $remote $PHABLET_ADDR/$name
     git fetch $remote
     git merge $revision
     echo "$path $revision" >> $log_file 
     popd
 else
    echo "$path name $revision" >> $not_exist_folder.log
 fi
EOF
echo
}

main(){
local path=
local name=
local revision=
local folder_neednot_merge=$TMP_FLODER/folder_neednot_merge.log


while read file ; do
for token in $file
do
        [ `echo $token | grep path` ] && path=`echo $token | awk -F'=' '{print $2}' | sed 's/\"//g'`
        [ `echo $token | grep name` ] && name=`echo $token | awk -F'=' '{print $2}' | sed 's/\"//g'`
        [ `echo $token | grep revision` ] && revision=`echo $token | awk -F'=' '{print $2}' | sed 's/\"//g'`
done
[ "$name" == "" ] || {
    if [ -z $revision ]; then 
        echo $path >> $folder_neednot_merge
    else
        merge $path $name $revision
    fi
}
path=
name=
revision=
done < $1
}

main $1
