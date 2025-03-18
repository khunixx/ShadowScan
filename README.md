# ShadowScan  

ShadowScan is a Bash script designed to automate network reconnaissance while ensuring user anonymity. It verifies anonymity before scanning, connects securely to a remote server, and retrieves Whois and Nmap scan data for analysis. This tool is designed for penetration testers and cybersecurity professionals who need an efficient way to conduct remote reconnaissance.  

---

## Table of Contents  

1. [Overview](#overview)  
2. [Features](#features)  
3. [Prerequisites](#prerequisites)  
4. [Tested On](#tested-on)  
5. [Usage](#usage)  
6. [Script Workflow](#script-workflow)  
7. [Disclaimer](#disclaimer)  

---

## Overview  

ShadowScan aims to:  

- Verify user anonymity before running scans.  
- Connect securely to a remote server.  
- Perform Whois and Nmap scans on a specified target machine.  
- Store scan results and logs locally for later analysis.  

### Use Cases:  

- Remote network reconnaissance.  
- Penetration testing and security assessments.  
- Research on open ports, services, and Whois data.  

---

## Features  

### 1. Automated Dependency Check  
- Ensures required packages (**nmap**, **geoip-bin**, **sshpass**, **nipe**) are installed.  

### 2. Anonymity Verification  
- Uses `geoiplookup` to confirm that the user is operating under an anonymous IP.  
- If anonymity is not detected, the script exits to prevent exposure.  

### 3. Secure Remote Scanning  
- Establishes an SSH connection to a remote server.  
- Runs Whois and Nmap scans on a user-specified target.  
- Retrieves scan results and saves them locally.  

### 4. Logging and Documentation  
- Outputs Whois and Nmap scan data in text format.  
- Creates an audit log in `/var/log/sshpass.log` for record-keeping.  

---

## Prerequisites  

This script checks for and installs the following tools if they are not already present:  

- [**nmap**](https://nmap.org/) – Port scanning and service enumeration.  
- [**geoip-bin**](https://tracker.debian.org/pkg/geoip-bin) – IP geolocation lookup.  
- [**sshpass**](https://sourceforge.net/projects/sshpass/) – Non-interactive SSH authentication.  
- [**nipe**](https://github.com/htrgouvea/nipe) – Tor-based IP anonymization.  

> **Note**: The script relies on `apt-get` for package installation, so it’s primarily tested on **Debian/Ubuntu-based** systems.  

---

## Tested On  

- **Kali Linux** (Debian-based)  
- **Ubuntu 20.04+**  

It may work on other Debian/Ubuntu derivatives as well, provided the above tools can be installed via `apt-get`.  

---

## Usage  

### 1. Clone the Repository  

```bash
git clone https://github.com/khunixx/ShadowScan.git
cd ShadowScan
```

### 2. Make the Script Executable (if needed)  

```bash
chmod +x shadowscan.sh
```

### 3. Run the Script  

```bash
sudo ./shadowscan.sh
```

> The script requires `sudo` privileges because it needs to install packages and perform network scans that typically require elevated privileges.  

### 4. Follow the Prompts  

- Enter the username of the remote server.  
- Enter the IP address of the remote server.  
- Provide the password for SSH authentication.  
- Enter the IP address of the target machine.  

After completion, the script will save scan results in the current directory and generate an audit log in `/var/log/sshpass.log`.  

---

## Script Workflow  

### 1. CHECK  
- Verifies that the script is running as root.  
- Checks for installed dependencies and installs missing packages.  

### 2. ANONYMITY CHECK  
- Uses `geoiplookup` to confirm that the user is anonymous.  
- If the user is not anonymous, the script exits.  

### 3. REMOTE CONNECTION  
- Establishes an SSH connection to the remote server.  
- Retrieves server details such as IP, country, and uptime.  

### 4. WHOIS SCAN  
- Performs a Whois lookup on the target machine.  
- Saves the output in `whois.txt`.  

### 5. NMAP SCAN  
- Executes an Nmap scan to detect open ports and running services.  
- Saves the output in `nmap.txt`.  

### 6. AUDIT LOGGING  
- Creates an audit log in `/var/log/sshpass.log`, storing:  
  - Date and time of the scan.  
  - Remote server details.  
  - Target machine IP.  
  - Whois and Nmap scan results.  

---

## Disclaimer  

This tool is intended for **legal security testing and educational purposes** only. Unauthorized use against systems without explicit permission is strictly prohibited.  
