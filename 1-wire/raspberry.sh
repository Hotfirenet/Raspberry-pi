#!/bin/bash
# Mon script de post installation desktop Debian 6.0.x
#
# Hotfirenet - 12-2012
# GPL
#
# Syntaxe: # sudo ./raspberry.sh

VERSION="1.00"
APT_GET="apt-get -q -y --force-yes"
WGET="wget -m --no-check-certificate"
DATE=`date +"%Y%m%d%H%M%S"`
LOG_FILE="/tmp/ownfs-$DATE.log"

# Fonctions utilisées par le script
#---------------------------------

displaymessage() {
  echo "$*"
}

displaytitle() {
  displaymessage "------------------------------------------------------------------------------"
  displaymessage "$*"
  displaymessage "------------------------------------------------------------------------------"

}

displayerror() {
  displaymessage "$*" >&2
}

# Premier parametre: ERROR CODE
# Second parametre: MESSAGE
displayerrorandexit() {
  local exitcode=$1
  shift
  displayerror "$*"
  exit $exitcode
}

# Premier parametre: MESSAGE
# Autres parametres: COMMAND
displayandexec() {
  local message=$1
  echo -n "[En cours] $message"
  shift
  echo ">>> $*" >> $LOG_FILE 2>&1
  sh -c "$*" >> $LOG_FILE 2>&1
  local ret=$?
  if [ $ret -ne 0 ]; then
    echo -e "\r\e[0;31m   [ERROR]\e[0m $message"
  else
    echo -e "\r\e[0;32m      [OK]\e[0m $message"
  fi
  return $ret
}

# Debut du programme
#-------------------

# Test que le script est lance en root
if [ $EUID -ne 0 ]; then
  displayerror 1 "Le script doit être lancé en root: # su - -c $0"
fi

# Création du fichier de log
echo "Debut du script" > $LOG_FILE

apt-get update && upgrade

if [ `lsusb | grep -c "Dallas Semiconductor DS1490F"` -ge 1 ]
	then
		apt-get install owserver ow-shell owhttpd owfs-fuse

		wget https://raw.github.com/Hotfirenet/Raspberry-pi/master/1-wire/owfs.conf
		mv owfs.conf /etc/

		mkdir /mnt/1wire/
		owfs -s localhost:4304 -m /mnt/1wire/

		/etc/init.d/owserver restart
	else 
		echo il faut connecter le DS1490
fi
		