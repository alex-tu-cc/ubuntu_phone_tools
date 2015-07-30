#!/bin/bash
set -e
#set -x
picked_folder=
picked=0

usage(){
cat<< EOF
    Used to pickup folder that have conflict which needed to be fixed.
    $(basename $0) the-file-of-output-from-parse_and_merge.sh 
    ex. $(basename $0) merge.log
EOF
}


while read file; do

    #find conflict
    [ -z $picked_folder ] || {
        [ "0" != "$(expr "$file" : "^CONFLICT")" ] && {
            echo $picked_folder    
            picked_folder=
        }
    }
    [ "0" != "$(expr "$file" : "^~*")" ] && {
        picked_folder=$(echo $file | awk '{ print $1 }')
    }

done < $1
