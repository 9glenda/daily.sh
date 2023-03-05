#!/bin/sh

backup() { # Sunday
    echo "Sunday, time to backup your files"
    ~/backup.sh 
}

update() {
    echo "time to update your system"
    ~/update.sh
}
