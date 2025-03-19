#!/bin/bash

# Color variables
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
PINK='\033[1;35m'
RESET='\033[0m' # No Color

function CHECK () {
	echo
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

	NIPE_DIR=$(find / -type d -name "nipe" -print 2>/dev/null | head -n 1)
	if [ -n "$NIPE_DIR" ]; then
		echo -e "${GREEN}Nipe${RESET} is installed"
	else
		echo "Installing Nipe..."
		git clone https://github.com/htrgouvea/nipe ~/nipe
		cd ~/nipe
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

}

function ANON () {
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
}

function DIR () {
	echo
	while true; do
        read -p "Please enter the name of the directory you wish to create. All results will be saved in this directory: " OUT_DIR
        read -p "You have chosen the name '$OUT_DIR'. Is this input correct? (y/n): " ANS
        if [[ $ANS == "y" || $ANS == "Y" ]]; then
            if [[ -d "$OUT_DIR" ]]; then
                echo "Directory '$OUT_DIR' already exists. Please choose another name."
            else
                echo -e "Creating the directory ${BLUE}$OUT_DIR${RESET}"
                mkdir $OUT_DIR
                break
            fi
        elif [[ $ANS == "n" || $ANS == "N" ]]; then
            echo "[-] Input is incorrect. Please try again."
        else
            echo "[-] Invalid answer. Please type 'y' or 'n'."
        fi
    done
}

function REMOTE () {
	# Ask for SSH credentials
	echo	
	read -p "Enter the username of the remote server: " RMUSR
	read -p "Enter the password of the remote server: " RMPASS
	read -p "Enter the IP of the remote server: " RMIP
	read -p "Enter the IP of the target machine for Nmap scan: " TARGET

	# Define the file path on the remote server
	NMAP_FILE="/home/$RMUSR/nmap_scan.txt"
	WHOIS_FILE="/home/$RMUSR/whois_scan.txt"

	# Step 1: Connect to the remote server and run Nmap
	echo
	echo -e "Connecting to $RMIP..."
	sshpass -p "$RMPASS" ssh -t -q -o StrictHostKeyChecking=no $RMUSR@$RMIP >/dev/null 2>&1 <<EOF
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
	
    echo -e "Starting ${BLUE}Nmap${RESET} scan..."
    nmap -Pn -sV $TARGET > $NMAP_FILE
    echo "Nmap scan completed. Results are saved to $NMAP_FILE"
    echo "Starting Whois check..." 
    whois $TARGET > $WHOIS_FILE
    echo "Whois check completed. Results are saved to $WHOIS_FILE"
EOF

	# Copying the nmap and whois files to the local machine
	echo -e "Copying the ${PINK}Nmap${RESET} and ${PINK}whois${RESET} results from $RMIP to local machine..."
	sshpass -p "$RMPASS" scp $RMUSR@$RMIP:$NMAP_FILE $OUT_DIR/nmap_res.txt
	sshpass -p "$RMPASS" scp $RMUSR@$RMIP:$WHOIS_FILE $OUT_DIR/whois_res.txt

	# Deleting the files from the remote machine
	sshpass -p "$RMPASS" ssh -q -o StrictHostKeyChecking=no $RMUSR@$RMIP "rm -f $NMAP_FILE $WHOIS_FILE"

}

function AUDIT () {
	# creating an audit log
	sleep 1
	echo
	echo -e "${PURPLE}Creating an audit log...${RESET}"
{
    echo "Audit Log"
    echo "Date: $(date)"
    echo "Remote Server: $RMIP"
    echo "Target Machine: $TARGET"
    echo "Whois Data:"
    cat $OUT_DIR/whois_res.txt
    echo "Nmap Data:"
    cat $OUT_DIR/nmap_res.txt
} > $OUT_DIR/audit.log

}

CHECK
DIR
ANON
REMOTE
AUDIT
