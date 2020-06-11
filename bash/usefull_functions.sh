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
    echo -e "${TEXTYEL}[WARNING] ${1} ${RS}"
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


m_der2pem(){
    if [[ $# -eq 0 ]]; then
        printNotice "m_der2pem /path/to/cert.cer "
        return 0
    fi

    FILE=$(basename ${1})
    FOLDER=$(dirname ${FILE})

    openssl x509 -in "${FOLDER}/${FILE}" -out "${FOLDER}/${FILE}.pem" -inform der -outform pem
    echo "[>] Your certificate is saved at: ${FOLDER}/${FILE}"
}

m_createp12(){
    PASSWORD=$(date +%s | sha256sum | base64 | head -c 32)
    BASEPATH="~/Certificaten/SelfSigned"
    mkdir -p ${BASEPATH}
    CERTNAME="$1"
    SUBJECT="/CN=${CERTNAME}"
    openssl req -x509 -nodes -sha256 -days 3650 -newkey rsa:4096 -keyout "${BASEPATH}/${CERTNAME}.key" -out "${BASEPATH}/${CERTNAME}.pem" -subj "$SUBJECT" >/dev/null
    openssl pkcs12 -export -out "${BASEPATH}/${CERTNAME}.${PASSWORD}.pfx" -inkey "${BASEPATH}/${CERTNAME}.key" -in "${BASEPATH}/${CERTNAME}.pem" -passout pass:${PASSWORD} >/dev/null 
    echo "Created ${BASEPATH}/${CERTNAME}.${PASSWORD}.pfx"
}


m_download_certificate(){
    if [[ $# -eq 0 ]]; then
        printNotice "Usage: m_download_certificate <host> <port> [/path/to/certificate.pem]"
        printNotice "------------"
        printNotice " <host>: required"
        printNotice " <port>: required"
        printNotice " [path]: optional default /tmp/"
        printNotice "------------"
        return 0
    fi
    HOST=${1}
    PORT=${2}
    SAVE=${3:-/tmp/${HOST}.pem}
    echo "QUIT" | openssl s_client -showcerts -connect ${HOST}:${PORT:-443} | openssl x509 -out ${SAVE}
    printSuccess "Your certificate is saved at: ${SAVE}"
}

##------------------------
# NETWORK FUNCTIONS
##------------------------

m_nc(){
    if [[ $# -eq 0 ]]; then
        printNotice "Usage: m_nc <host> <port>"
        printNotice "------------"
        printNotice " <host>: required"
        printNotice " <port>: required"
        printNotice "------------"
        return 0
    fi
    HOST=${1}
    PORT=${2}
    printSuccess $(echo "QUIT" | nc -w 1 -v $HOST $PORT)
}
