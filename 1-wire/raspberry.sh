#!/bin/bash
# Mon script de post installation desktop Debian 6.0.x
#
# Hotfirenet - 12-2012
# GPL
#
# Syntaxe: # sudo ./raspberry.sh

VERSION="1.00"

if [ `lsusb | grep -c "DDallas Semiconductor DS1490F"` == 1 ]
	then
		apt-get install owserver ow-shell owhttpd owfs-fuse;

		wget https://github.com/Hotfirenet/Raspberry-pi/blob/master/1-wire/owfs.conf;
		mv owfs.conf /etc/;

		mkdir /mnt/1wire/;
		owfs -s localhost:4304 -m /mnt/1wire/;

		/etc/init.d/owserver restart;
	else 
		echo il faut connecter le DS1490
fi
		