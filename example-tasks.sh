#!/bin/sh

status() { # Status
  echo "Status"
}
backup() { # Tuesday
    echo "Sunday, time to backup your files"
    read -n 1 -r yn
    if [ "$yn" == "y" ];then
    #~/backup.sh 
    echo "backup"
    fi
}

update() {
    echo "time to update your system"
    #~/update.sh
}
