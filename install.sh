#!/bin/sh

# ----- Module Installer -----
# (C) gacorpkjrt°

SKIPMOUNT=false
PROPFILE=false
POSTFSDATA=true
LATESTARTSERVICE=true

cpu=$(cat /proc/cpuinfo | grep "Hardware" | uniq | cut -d ":" -f 2)
sdm=$(echo $cpu | grep -o "SDM")
mtk=$(echo $cpu | grep -o "MT")

mod_print() {
ui_print ""
ui_print "░█▀█░█▀▀░█▀▀░█▀█░▀█▀░█▀█░█░█░█▀▀░█░█
░█░█░█░█░█▀▀░█░█░░█░░█░█░█░█░█░░░█▀█
░▀░▀░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀"
ui_print "_____________________________________________"
ui_print "   Feel The Responsivess and Smoothess !  "
sleep 2s
ui_print ""
ui_print "[~] Checking Your Device"
ui_print " Device -> $(getprop ro.product.system.device)"
sleep 1s
ui_print " Kernel -> $(uname -r)"
sleep 1s
ui_print " Brand -> $(getprop ro.product.system.brand)"
sleep 1s
if [[ $sdm == "SDM" ]]; then
cpus=Snapdragon
elif [[ $mtk == "MT" ]]; then
cpus=Mediatek
fi
ui_print " CPU -> $cpus$cpu"
ui_print ""
sleep 1s
}

extract_files() {
unzip -o "$ZIPFILE" 'post-fs-data.sh' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'service.sh' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'script/*' -d $MODPATH >&2
}

perm() {
set_perm_recursive $MODPATH 0 0 0777 0777
}

set -x
mod_print
extract_files
perm