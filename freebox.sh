#!/bin/bash

fbxLogin='freebox'
fbxPasswd=''

fbxCookieFile="/tmp/fbxCookie.txt"

fbxLogin() {
    curl --cookie-jar $fbxCookieFile -s -o /dev/null -L "http://mafreebox.freebox.fr/login.php?login=$fbxLogin&passwd=$fbxPasswd"
    if [ $? -ne 0 ]; then
       echo "Login to Freebox failed!"
       exit 0
    fi
}

fbxLogout() {
    curl -b $fbxCookieFile -s -o /dev/null -L 'http://mafreebox.freebox.fr/login.php?logout=1'
    rm -f $fbxCookieFile
    if [ $? -ne 0 ]; then
       echo "Logout of Freebox failed!"
    fi
}

wifiOn() {
    fbxLogin
    curl -b $fbxCookieFile -s -o /dev/null -d 'enabled=on&channel=9&ht_mode=20&method=wifi.ap_params_set&config=Valider'  -H "X-Requested-With: XMLHttpRequest" -L 'http://mafreebox.freebox.fr/wifi.cgi'
    if [ $? -ne 0 ]; then
        echo "Setting Freebox wifi ON failed!"
    fi
    fbxLogout
}

wifiOff() {
    fbxLogin
    curl -b $fbxCookieFile -s -o /dev/null -d 'channel=9&ht_mode=20&method=wifi.ap_params_set&config=Valider'  -H "X-Requested-With: XMLHttpRequest" -L 'http://mafreebox.freebox.fr/wifi.cgi'
    if [ $? -ne 0 ]; then
        echo "Setting Freebox wifi OFF failed!"
    fi
    fbxLogout
}

wifiStatus() {
    fbxLogin
    checked=$(curl -b $fbxCookieFile -s -L 'http://mafreebox.freebox.fr/settings.php?page=wifi_conf' | grep '<input type="checkbox" name="enabled" checked />')

    rc=0
    if [ "$checked" != "" ]; then
        echo "Freebox Wifi is ON"
        rc=1
    else
        echo "Freebox Wifi is OFF"
    fi

    fbxLogout
    exit $rc
}

fbxReboot() {
    fbxLogin

    curl -b $fbxCookieFile -s -o /dev/null -d 'method=system.reboot&timeout=1&reboot=Red%C3%A9marrer+la+freebox'  -H "X-Requested-With: XMLHttpRequest" -L 'http://mafreebox.freebox.fr/system.cgi' 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "Request to reboot the Freebox has failed!"
    fi
}


case "$1" in
    wifiOn)
        wifiOn
        exit 1
        ;;
    wifiOff)
        wifiOff
        exit 0
        ;;
    wifiStatus)
        wifiStatus
        exit $?
        ;;
    fbxReboot)
        fbxReboot
        exit $?
        ;;
    *)
        echo "Usage: $0 {wifiOn|wifiOff|wifiStatus|fbxReboot}"
        exit 0
esac

exit 0
