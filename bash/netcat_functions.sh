#!/bin/bash

netcat_bin=`which nc`

tnc(){
    if [[ $# -eq 0 ]]; then
        echo "Usage: tnc <host> <port>"
        echo "------------"
        echo " <host>: required"
        echo " <port>: required"
        echo "------------"
        return 0
    fi
    HOST=${1}
    PORT=${2}
    echo "QUIT" | ${netcat_bin} -w 1 -v $HOST $PORT
}
