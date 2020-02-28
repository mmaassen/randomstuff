#!/bin/bash
#--------------------------------------------
# Color Codes
#--------------------------------------------
RS="\033[0m"
TEXTRED="\033[31m"
TEXTGRN="\033[32m"
TEXTYEL="\033[33m"
TEXTBLU="\033[34m"
TEXTMAG="\033[35m"
TEXTCYN="\033[36m"
TEXTWHT="\033[37m"

#--------------------------------------------
# Print Functions
#--------------------------------------------
printSep(){
    echo "-----------------------"
    echo " [>] $1"
    echo "-----------------------"
}

printError(){
    echo -e "${TEXTRED}[ERROR] ${1} ${RS}"
}
printWarning(){
    echo -e "${TEXTYEL}[ERROR] ${1} ${RS}"
}
printNotice(){
    echo -e "${TEXTCYN}[NOTICE] ${1} ${RS}"
}
printInfo(){
    echo -e "[INFO] ${1} "
}

printDebug(){
    if [[ $DEBUG ]]; then
        echo -e "${TEXTBLU}[DEBUG][$(date)] ${1} ${RS}"
    fi
}
printDevel(){
    if [[ $DEBUG ]]; then
        echo -e "${TEXTMAG}[DEVEL][$(date)] ${1} ${RS}"
    fi
}

printSuccess(){
    echo -e "${TEXTGRN}[>] ${1} ${RS}"
}

printMenu(){
    echo -e "${TEXTCYN}${1}${RS}"
}

##------------------------
# CERTIFICATE FUNCTIONS
##------------------------


der2pem(){
    if [[ $# -eq 0 ]]; then
        echo "$(basename $0) /path/to/cert.cer "
        return 0
    fi

    FILE=$(basename ${1})
    FOLDER=$(dirname ${FILE})

    openssl x509 -in "${FOLDER}/${FILE}" -out "${FOLDER}/${FILE}.pem" -inform der -outform pem
    echo "[>] Your certificate is saved at: ${FOLDER}/${FILE}"
}




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
    echo "QUIT" | openssl s_client -showcerts -connect ${HOST}:${PORT:-443} | openssl x509 -out ${SAVE}
    printSuccess "[>] Your certificate is saved at: ${SAVE}"
}

##------------------------
# NETWORK FUNCTIONS
##------------------------

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
    printSuccess "QUIT" | nc -w 1 -v $HOST $PORT
}