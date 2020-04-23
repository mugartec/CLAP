#!/bin/bash 

set -o nounset
set -o errexit
set -o pipefail

BASE_DIR="${HOME}/.clap"
PASS_DIR="${BASE_DIR}/data"
NEW_PASS_DIR="${BASE_DIR}/data_new"
CONF_DIR="${BASE_DIR}/conf"
CONF_FILE="${CONF_DIR}/clap.conf"
BACKUP_DIR="${BASE_DIR}/backups/$(date +"%Y-%m-%d_%T")/.clap"


function ask_password(){
    IFS="" read -p "${1}" -s -r passwd ; echo 
    printf -v passwd "%q" "$passwd" #scape special characters
    eval $2="'$passwd'"
    unset passwd
}

function ask_master_password(){
    salt=$(head -n 1 "$CONF_FILE")
    h=$(tail -1 "$CONF_FILE")
    ask_password "Insert master password (hidden): " _master
    _result=$(echo "$_master${salt}" | sha256sum)
    if [ "${_result: 0: -3}" = "$h" ]; then
        eval $1="$_master"
    else
        echo "Wrong password, bye!"
        exit 1
    fi
    unset _master
    unset _result
}


function password_input(){
    ask_password "Insert new password (hidden): " _pass
    eval $1="$_pass"
    unset _pass
}


ask_master_password old_master
password_input new_master
printf -v escaped_new_master "%q" "$new_master" #scape special characters

echo "Backing up, in case of emergency restore ${BACKUP_DIR} to your home"
mkdir -p $BACKUP_DIR
cp -r $BASE_DIR/data $BACKUP_DIR/
cp -r $BASE_DIR/conf $BACKUP_DIR/

new_salt=$(head /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 30)
checksum=$(echo "${escaped_new_master}${new_salt}" | sha256sum)

echo "Updating configuration file ${CONF_FILE} with new master password and salt"
printf "${new_salt}\n${checksum: 0: -3}" > "${CONF_FILE}"

echo "Updating $(ls -1q ${PASS_DIR}/* | wc -l) encrypted files..."
for entry in "$PASS_DIR"/*
do
    pass=$(openssl aes-256-cbc -d -pbkdf2 -k "$old_master" -in "$entry")
    echo -n "$pass" | openssl aes-256-cbc -pbkdf2 -k "$new_master" -out "$entry"
done
echo "All OK"
