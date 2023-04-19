#!/usr/bin/bash
[ $(whoami) != "root" ] && echo "ERROR: This script require root to run. please proceed with sudo or root account" && exit 1
LATEST_URL=$(curl -s "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" | grep -o 'https://[^\"]*')
[ "$?" = "1" ] && echo "ERROR: Failed to fetch latest version information. please check internet connection" && exit 1
LATEST_VERSION=$(echo $LATEST_URL | grep -oP "(?<=releases/)([0-9\.]*)")
[ -e /opt/firefox ] && [ $(grep -oP "(?<=Version=)[\d\.]*" /opt/firefox/application.ini | head -n 1) = $LATEST_VERSION ] && echo "Firefox is up to date. Nothing changed" && exit 0
[ -e /opt/firefox ] && (echo "A previous Firefox installation was found. Uninstall previous installation . . ."; rm -rf /opt/firefox; rm -f /usr/local/bin/firefox; rm -f /usr/local/share/applications/firefox.desktop)
echo "Get latest build from download.mozilla.org . . ."; wget -q $LATEST_URL -O firefox.tar.bz2
[ "$?" = "1" ] && echo "ERROR: Failed download tar file. please check internet connection" && exit 1
echo "Unpacking . . ."; tar xfj firefox.tar.bz2 -C /opt; ln -s /opt/firefox/firefox /usr/local/bin/firefox
echo "Create .desktop file . . ."; wget -q https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop -O /usr/local/share/applications/firefox.desktop
[ "$?" = "1" ] && echo "ERROR: Failed firefox.desktop. please check internet connection" && exit 1
(which update-desktop-database 2>/dev/null 1>/dev/null); [ "$?" = "0" ] && (echo "Updating desktop database . . ."; update-desktop-database)
echo "Firefox $LATEST_VERSION installed successfully!"; exit 0
