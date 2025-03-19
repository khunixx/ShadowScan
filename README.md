# Network Scan Automation Script

This script is an **automated network scanning and reconnaissance tool** designed for cybersecurity professionals and penetration testers. It automates **dependency checks, anonymity verification, remote scanning, and structured logging** to assist in security assessments and forensic analysis.

---

## Table of Contents  
1. [Overview](#overview)  
2. [Features](#features)  
3. [Prerequisites](#prerequisites)  
4. [Tested On](#tested-on)  
5. [Usage](#usage)  
6. [Script Workflow](#script-workflow)  

---

## Overview  
This script performs the following network penetration testing and reconnaissance tasks:

- **Dependency Checks** – Ensures essential tools (`sshpass`, `nmap`, `geoip-bin`, `nipe`) are installed.
- **Anonymity Verification** – Confirms whether the user is anonymous using a proxy.
- **Remote Scanning** – Executes `nmap` and `whois` on a target system via an SSH connection.
- **Automated Logging** – Captures scan results and generates structured logs for analysis.
- **Secure File Handling** – Transfers scan results to the local system and removes them from the remote machine.

### Use Cases:  
- **Penetration Testing** – Identify vulnerable services, open ports, and exposed system information.  
- **Red Team Operations** – Automate reconnaissance before launching advanced exploits.  
- **Security Auditing** – Perform **network mapping, passive fingerprinting, and active scanning**.  

---

## Features  
### 1. Automated Dependency Check  
- Ensures **`sshpass`, `nmap`, `geoip-bin`, `nipe`** are installed.  
- Installs missing dependencies if necessary.  

### 2. Anonymity Check  
- Uses **Nipe** and `geoiplookup` to determine if the system is routing traffic through a proxy.  

### 3. Directory Management  
- Prompts the user to create a **custom output directory** for storing scan results.  
- Ensures **directory uniqueness** to prevent overwrites.  

### 4. Remote Network Scanning  
- Uses **SSH (`sshpass`)** to connect to a remote machine and execute scans.  
- Runs **`nmap -Pn -sV`** to enumerate live hosts and open services.  
- Performs a **Whois lookup** to extract domain information.  

### 5. Secure Data Transfer  
- Uses **SCP (`sshpass`)** to retrieve scan results from the remote server.  
- Ensures results are saved in the predefined output directory.  
- Automatically deletes scan files from the remote system after transfer.  

### 6. Logging & Audit Trail  
- Generates a **detailed audit log (`audit.log`)** with:
  - Timestamped scan results  
  - Remote server details  
  - Target IP and domain metadata  
  
---

## Prerequisites  
This script requires the following tools:

- **sshpass** – Enables SSH authentication with passwords.
- **nmap** – Performs network scanning and service detection.
- **geoip-bin** – Determines IP geolocation information.
- **nipe** – Routes traffic through the Tor network for anonymity.

> **Note:** The script relies on `apt-get` for package installation and is tested on **Debian-based distributions**.

---

## Tested On  
- **Kali Linux** (Debian-based)  
- **Ubuntu 20.04+**  

---

## Usage  
### 1. Clone the Repository  
```bash
git clone https://github.com/khunixx/NetworkScanTool.git
cd NetworkScanTool
```

### 2. Make the Script Executable  
```bash
chmod +x network_scan.sh
```

### 3. Run the Script  
```bash
sudo ./network_scan.sh
```

### 4. Follow the Prompts  
- Enter **the output directory name**.
- Provide **SSH credentials for remote access**.
- Specify **the target machine’s IP address**.
- The script will execute scans and store results locally.

---

## Script Workflow  
### 1. CHECK  
- Ensures root access and verifies dependencies.  
- Installs missing packages using `apt-get`.  

### 2. ANON  
- Verifies anonymity status via **Nipe and GeoIP lookup**.  
- Displays the **public IP and country of origin**.  

### 3. DIR  
- Prompts the user to create a directory for saving scan results.  

### 4. REMOTE  
- Connects to the **remote server via SSH**.  
- Runs **Nmap and Whois scans** on the target machine.  
- Saves scan results on the remote machine.  
- Transfers results to the **local machine via SCP**.  
- Deletes scan files from the remote server after transfer.  

### 5. AUDIT  
- Logs all scan results in `audit.log`.  
- Captures **timestamp, remote server details, scan output, and target metadata**.  

---

## License  
This script is provided "as is" without any guarantees. Use responsibly.
