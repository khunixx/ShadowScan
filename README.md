ShadowScan
ShadowScan is a Bash script designed to automate network reconnaissance while ensuring user anonymity. It verifies anonymity before scanning, connects securely to a remote server, and retrieves Whois and Nmap scan data for analysis. This tool is designed for penetration testers and cybersecurity professionals who need an efficient way to conduct remote reconnaissance.

Table of Contents
Overview
Features
Prerequisites
Tested On
Usage
Script Workflow
Disclaimer
Overview
ShadowScan aims to:

Verify user anonymity before running scans.
Connect securely to a remote server.
Perform Whois and Nmap scans on a specified target machine.
Store scan results and logs locally for later analysis.
Use Cases:

Remote network reconnaissance.
Penetration testing and security assessments.
Research on open ports, services, and Whois data.
Features
Automated Dependency Check

Ensures required packages (nmap, geoip-bin, sshpass, nipe) are installed.
Anonymity Verification

Uses geoiplookup to confirm that the user is operating under an anonymous IP.
If anonymity is not detected, the script exits to prevent exposure.
Secure Remote Scanning

Establishes an SSH connection to a remote server.
Runs Whois and Nmap scans on a user-specified target.
Retrieves scan results and saves them locally.
Logging and Documentation

Outputs Whois and Nmap scan data in text format.
Creates an audit log in /var/log/sshpass.log for record-keeping.
Prerequisites
This script checks for and installs the following tools if they are not already present:

nmap – Port scanning and service enumeration.
geoip-bin – IP geolocation lookup.
sshpass – Non-interactive SSH authentication.
nipe – Tor-based IP anonymization.
Note: The script relies on apt-get for package installation, so it’s primarily tested on Debian/Ubuntu-based systems.

Tested On
Kali Linux (Debian-based)
Ubuntu 20.04+
It may work on other Debian/Ubuntu derivatives as well, provided the above tools can be installed via apt-get.

Usage
Clone the Repository:

bash
Copy
Edit
git clone https://github.com/khunixx/ShadowScan.git
cd ShadowScan
Make the Script Executable (if needed):

bash
Copy
Edit
chmod +x shadowscan.sh
Run the Script:

bash
Copy
Edit
sudo ./shadowscan.sh
The script requires sudo privileges because it needs to install packages and perform network scans that typically require elevated privileges.

Follow the Prompts:

Enter the username of the remote server.
Enter the IP address of the remote server.
Provide the password for SSH authentication.
Enter the IP address of the target machine.
After completion, the script will save scan results in the current directory and generate an audit log in /var/log/sshpass.log.

Script Workflow
CHECK

Verifies that the script is running as root.
Checks for installed dependencies and installs missing packages.
ANONYMITY CHECK

Uses geoiplookup to confirm that the user is anonymous.
If the user is not anonymous, the script exits.
REMOTE CONNECTION

Establishes an SSH connection to the remote server.
Retrieves server details such as IP, country, and uptime.
WHOIS SCAN

Performs a Whois lookup on the target machine.
Saves the output in whois.txt.
NMAP SCAN

Executes an Nmap scan to detect open ports and running services.
Saves the output in nmap.txt.
AUDIT LOGGING

Creates an audit log in /var/log/sshpass.log, storing:
Date and time of the scan.
Remote server details.
Target machine IP.
Whois and Nmap scan results.
