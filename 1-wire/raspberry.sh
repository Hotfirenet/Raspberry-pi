#!/bin/bash
# Mon script de post installation desktop Debian 6.0.x
#
# Hotfirenet - 12-2012
# GPL
#
# Syntaxe: # sudo ./raspberry.sh

VERSION="1.00"

#=============================================================================
# Liste des applications installés par le script
# A adapter à vos besoins...
#-----------------------------------------------------------------------------

lsusb
apt-get install owserver ow-shell owhttpd owfs-fuse

wget 

mkdir /mnt/1wire/
owfs -s localhost:4304 -m /mnt/1wire/

/etc/init.d/owserver restart