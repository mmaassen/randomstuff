## Some random functions to embed in your bash scripts
## Use:
# wget --quite --no-check-certificate https://raw.githubusercontent.com/mmaassen/randomstuff/master/Scripts/functions.sh -O /tmp/mmaassen-functions.sh
# source /tmp/mmaassen-functions.sh
##
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
# Other functions
#--------------------------------------------

spinner(){
    PID=$1
    i=1
    # sp="/-\|"
    sp=".oO@*@Oo"
    echo -n ' '
    while [ -d /proc/$PID ]
    do
      printf "\b${sp:i++%${#sp}:1}"
      sleep 0.3
    done
}


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


#--------------------------------------------
# Vars
#--------------------------------------------
