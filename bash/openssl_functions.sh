#!/bin/bash

openssl_bin=`which openssl`

openssl_download_certificate(){
    if [[ $# -eq 0 ]]; then
        echo "Usage: openssl_download_certificate <host> <port> [/path/to/certificate.pem]"
        echo "------------"
        echo " <host>: required"
        echo " <port>: required"
        echo " [path]: optional default /tmp/"
        echo "------------"
        return 0
    fi
    HOST=${1}
    PORT=${2}
    SAVE=${3:-/tmp/${HOST}.pem}
    echo "QUIT" | ${openssl_bin} s_client -showcerts -connect ${HOST}:${PORT:-443} | ${openssl_bin} x509 -out ${SAVE}
    echo "[>] Your certificate is saved at: ${SAVE}"
}
