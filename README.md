# Automated Network Scan Script

## Overview
This script automates a network scanning process using `nmap` and `whois`. It checks for necessary dependencies, verifies anonymity, connects to a remote machine, runs network scans, retrieves the results, and logs the findings.

## Features
- Checks if required tools (`sshpass`, `nmap`, `geoip-bin`, `nipe`) are installed.
- Ensures anonymity before scanning.
- Creates a directory for storing results.
- Connects to a remote server via `sshpass`.
- Runs `nmap` and `whois` on a target machine.
- Copies results back to the local machine.
- Deletes scan files from the remote server.
- Generates an audit log.

## Dependencies
Ensure the following packages are installed:
- `sshpass`
- `nmap`
- `geoip-bin`
- `nipe`

## Usage
Run the script with:
```bash
sudo bash script_name.sh
```

## Function Breakdown
### `CHECK()`
- Verifies and installs required dependencies.
- Ensures `nmap`, `sshpass`, and `geoip-bin` are installed.
- Checks if `nipe` is available; installs if missing.

### `ANON()`
- Checks if the system is using a proxy (via `nipe`).
- Displays IP and country details.

### `DIR()`
- Prompts the user to create a directory for storing scan results.
- Ensures the directory does not already exist.

### `REMOTE()`
- Prompts for remote SSH credentials.
- Executes `nmap` and `whois` on the target machine.
- Saves scan results on the remote machine.
- Copies results to the local directory.
- Deletes scan files from the remote machine.

### `AUDIT()`
- Creates a detailed audit log including:
  - Date and time
  - Remote server details
  - Target machine information
  - Whois and Nmap scan results

## Output
- Scan results are saved in the specified directory.
- Audit log is generated as `audit.log`.

## Notes
- Ensure you have appropriate permissions to run `sudo` commands.
- The script requires SSH access to the remote server.
- Use with caution to avoid unauthorized scanning.

## License
This script is provided "as is" without any guarantees. Use responsibly.
