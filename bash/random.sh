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
# Check functions
#--------------------------------------------
fileExists(){
    if [[ ! -f "$1" ]]; then
        echo "[ERROR] File not found"
        echo "$1"
        echo ""
        exit 1
    fi
}

checkSudo(){
    if [ $(id -u) -ne 0 ]; then
        echo "[ERROR] Gebruik sudo!"
        exit 1
    fi
}

hasSudo(){
    if groups $USER | grep &>/dev/null 'sudo'; then
        echo true
    else
        echo false
    fi
}

checkJava(){
    if [[ -d $JAVA_HOME ]]; then
        echo "[!] JAVA_HOME niet gevonden"
        echo "Mogelijk is er geen JDK geinstalleerd!"
        exit 1
    fi
}

checkInstalled(){
    APP=$1
    if [[ `dpkg -l | grep "$APP" -c` -gt 0 ]]; then
        echo "[!] $APP is al geinstalleerd!"
        exit 1
    fi
}

#--------------------------------------------
# Overige functions
#--------------------------------------------
stopWip(){
    echo "[!] Dit script is nog niet klaar voor gebruik!!"
    echo
    exit 1
}

sleeper(){
    NUM=$1
    echo "$NUM sec. geduld aub.."
    while [[ $NUM -ne 0 ]]; do
        echo -n "$NUM "
        let NUM=NUM-1
        sleep 1
    done
    echo
}

echoEpochNano(){
    date +%s%N
}

rePlaceHolder(){
    if [[ $# -ne 2 ]]; then
        # printError "rePlaceHolder requires 2 arguments"
        echo "rePlaceHolder requires 2 arguments"
    else
        PLACEHOLDER_FILE="$1"
        FILE_TO_EDIT="$2"
        cat $PLACEHOLDER_FILE | egrep '^[A-Z]' | while read line; do
            SEARCH=$(echo $line|awk -F'=' '{print $1}')
            REPLACE=$(echo $line|awk -F'=' '{print $2}')
            if grep "$SEARCH" "$FILE_TO_EDIT">/dev/null; then
                printNotice "Replace '$SEARCH' with '$REPLACE' in '$FILE_TO_EDIT'"
            fi
            sed -i "s#$SEARCH#$REPLACE#g" "$FILE_TO_EDIT"
        done

    fi
}

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
# Apt functions
#--------------------------------------------
updateRepo(){
    printSep "Updating apt repository"
    apt-get update >/dev/null &
    spinner $!
}

aptInstall(){
    printSep "Installing $@"
    apt-get install $@ -y >/dev/null &
    spinner $!
}

#--------------------------------------------
# Database functions
#--------------------------------------------
runQuery(){
    QUERY="$1"
    echo "$QUERY" | sudo -i -u postgres psql
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
