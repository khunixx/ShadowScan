#!/bin/bash

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
RESET='\033[0m' # No Color

echo -e "${GREEN}Authomated network scan will now begin${RESET}"

# Checking for update  
read -p "Have you updated your machine today? (y/n) " ANSWER
if [ "$ANSWER" == "y" ];
then 
        echo -e "The machine is ${GREEN}updated${RESET}"
else 
sudo apt-get update
fi

# Function to check if a package is installed
CHECK-PACKAGE () {
        dpkg -l | grep -qw "$1"
        return $?
}

sleep 1

echo -e "${GREEN}Assessing if the machine has the needed applications installed... ${RESET}" 
sleep 1

# checking if sshpass is installed 
if CHECK-PACKAGE "sshpass"; then
        echo -e "${GREEN}Sshpass${RESET} is installed"
else 
        echo "Installing sshpass..."
sudo apt-get install sshpass
fi

sleep 1

# Checking if nmap is installed 
if CHECK-PACKAGE "nmap"; then

        echo -e "${GREEN}Nmap${RESET} is installed"
else
        echo "Installing nmap..."
sleep 1
sudo apt-get install nmap 
fi

sleep 1

# checking if nipe is installed 
if [ -d "$HOME/nipe" ]; then
        echo -e "${GREEN}Nipe${RESET} is installed"
else
        echo "Installing nipe..."
sleep 1
git clone https://github.com/htrgouvea/nipe && cd nipe
sudo cpan install Try::Tiny Config::Simple JSON
sudo perl nipe.pl install
fi

sleep 1

# checking if geoip is installed
if CHECK-PACKAGE "geoip-bin"; then
        echo -e "${GREEN}Geoip${RESET} is installed"
else
        echo "Installing geoip..."
sleep 1
sudo apt-get install geoip-bin -y
fi

sleep 1 

echo -e "${GREEN}All necessary applications are installed.${RESET}"

#checking for anonymity 

sleep 1
IP=$(curl -s icanhazip.com) 
CNTRY=$(geoiplookup $IP | awk '{print $5}' | sed 's/,//g')
echo 
echo -e "${RED}Checking for anonymity${RESET}"

if [ "$CNTRY" == "Israel" ];
then
	sleep 1
        echo -e "You are ${RED}not${RESET} anonymous, exiting now..."
	exit
else 
	sleep 1
        echo -e "You are ${RED}anonymous${RESET}"
	echo -e "Your IP is ${RED}$IP${RESET}" 
        echo -e "Your country is : ${RED}$CNTRY${RESET}"
fi

sleep 1
echo
echo -e "${BLUE}Connecting to the remote server..${RESET}"
read -p "Please enter the username of the remote server: " RMUSR
read -p "Please enter the IP of the remote server: " RMIP
read -p "Please enter the password of the remote server: " RMPASS
read -p "Please enter the IP of the targeted machine: " TARGET
echo
# Connect to the remote server and retrieve details
sshpass -p "$RMPASS" ssh -o StrictHostKeyChecking=no $RMUSR@$RMIP <<EOF
echo
echo -e "${BLUE}Retrieving details of the remote server...${RESET}"

sleep 1
REMOTE_IP=\$(curl -s ifconfig.me)

COUNTRY=\$(curl -s https://ipinfo.io/\$REMOTE_IP/country)

UPTIME=\$(uptime -p)

echo -e "${BLUE}Remote Server Details:${RESET}"
sleep 1
echo -e "IP Address: ${BLUE}\$REMOTE_IP${RESET}"
sleep 1
echo -e "Country: ${BLUE}\$COUNTRY${RESET}"
sleep 1
echo -e "Uptime: ${BLUE}\$UPTIME${RESET}" 

# fetching whois
sleep 1
echo
echo -e "fetching ${BLUE}whois${RESET} information about the target"
whois $TARGET > ~/whois.txt
echo
sleep 1
# fetching nmap
echo -e "Scanning for ${BLUE}open ports${RESET} on $TARGET..."
nmap $TARGET > ~/nmap.txt
EOF

# saving the whois and nmap on the machine

sshpass -p "$RMPASS" scp $RMUSR@$RMIP:/home/$RMUSR/whois.txt .
sshpass -p "$RMPASS" scp $RMUSR@$RMIP:/home/$RMUSR/nmap.txt .

# creating an audit log
sleep 1
echo
echo -e "${PURPLE}Creating an audit log...${RESET}"
{
    echo "Audit Log"
    echo "Date: $(date)"
    echo "Remote Server: $RMIP"
    echo "Target Machine: $TARGET"
    echo "Whois Data: $(cat whois.txt)"
    echo "Nmap Data: $(cat nmap.txt)"
    
} > /home/kali/sshpass.log
