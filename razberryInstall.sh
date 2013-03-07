!/bin/bash
# Script d'installation de la carte fille Razberry
#
# Hotfirenet - 03/2013
# http://www.hotfirenet.com
#
# Syntaxe: # sudo ./razberryInstall.sh

VERSION="1.00"

# Ajouter la liste de vos logiciels séparés par des espaces
LISTE=""

# libargtable
LISTE=$LISTE" libargtable2-0 libargtable2-dev"

#=============================================================================

# Variables globales
#-------------------

HOME_PATH=`grep $USERNAME /etc/passwd | cut -d: -f6`
APT_GET="apt-get -q -y --force-yes"
WGET="wget -m --no-check-certificate"
DATE=`date +"%Y%m%d%H%M%S"`
LOG_FILE="/tmp/razberryInstall-$DATE.log"

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


# Installation des librairies
#---------------------------
displaytitle "-- Installation des logiciels suivants: $LISTE"
displayandexec "Installation des logiciels" $APT_GET install $LISTE

# Creation des répertoires zagent et en rep fils Certifications
#---------------------------
displaytitle "-- Création des répertoires zagent et Certifications"
displayandexec "Création des répertoires zagent" "mkdir zagent; cd zagent; mkdir Certifications"

# Téléchargement 
#---------------------------
displaytitle "-- Téléchargements des fichiers Run_Z-Agent.sh et z-agent"
displayandexec "Téléchargement de Run_Z-Agent.sh" $WGET https://z-cloud.googlecode.com/git/Z-Connector/Unix/Run_Z-Agent.sh
displayandexec "Téléchargement de z-agent" $WGET wget https://z-cloud.googlecode.com/git/Z-Connector/Unix/Release/Raspberry/z-agent

# On recherche l'adresse de la carte fille 
#---------------------------
displaytitle "-- On recherche l'adresse de la carte fille"
displayandexec "Recherche" "RESULTAT = `dmesg|grep cp210x|grep tty`; echo $RESULTAT"

 if [ $RESULTAT == "" ]; then  

 else 
 
 fi

# On applique les droits 
#---------------------------
displaytitle "-- On applique les droits "
displayandexec "Mise en place des droits" chmod u+x *

# Mise en place des certificats
displaytitle "-- Mise en place des certificats "
echo "Avez vous placé les certificats dans le répertoire ? (oui - non)"
read x

if [ $x == "yes" ] ; then

  # On lance 
  #---------------------------
  displayandexec "Lancement de Run_Z-Agent.sh" "./Run_Z-Agent.sh &"
  
fi

echo ""
echo "##############################################################################"
echo ""
echo "                            Fin du script (version $VERSION)"
echo ""
echo " Le log du script se trouve dans le fichier:"
echo "    $LOG_FILE"
echo ""
echo "##############################################################################"
echo ""


echo "Fin du script" >> $LOG_FILE





