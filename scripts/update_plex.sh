#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run script as root :)"
  exit
fi


echo -e "
 ________   ___        _______       ___    ___ 
|\   __  \ |\  \      |\  ___ \     |\  \  /  /|
\ \  \|\  \\ \  \     \ \   __/|    \ \  \/  / /
 \ \   ____\\ \  \     \ \  \_|/__   \ \    / / 
  \ \  \___| \ \  \____ \ \  \_|\ \   /     \/  
   \ \__\     \ \_______\\ \_______\ /  /\   \  
    \|__|      \|_______| \|_______|/__/ /\ __\ 
                                    |__|/ \|__| 
"
sleep 3
printf "Updating package repos...\n\n"
sleep 2
apt update
printf "\nStopping plexmediaserver.service...\n"
sleep 1
systemctl stop plexmediaserver.service
printf "Upgrading plexmediaserver package...\n\n"
sleep 2
apt install --only-upgrade plexmediaserver
printf "\nStarting plexmediaserver.service...\n"
sleep 1
systemctl start plexmediaserver.service
printf "Upgrade complete\n"