# Bash-Scripts

A collection of bash scripts I developed over time for other projects. This repo will be updated as I make more scripts. Each script contains a README file with all the information.

## This repository includes the following scripts:

- **Firewall rules to block known country IPs**: I developed this script as part of my final degree project. One of the project components required us to set up firewall rules for each of our VMs, to demonstrate that we understood how to do it. Through Project Honey Pot, I identified which countries were responsible for the most attacks. I then found a database containing IPv4 and IPv6 addresses from these countries and created this script, which essentially generates IPSets for them. This allowed me to create firewall rules that block incoming and outgoing traffic from these IP addresses.

- **GCP Elasticity Script**: This script dynamically manages Google Cloud Compute Engine VM instances based on the average CPU usage of currently running instances whose names start with "servidor" (I used this for my servers but you can change it to whatever you need!). It automates the process of starting and stopping instances depending on system load, providing elasticity to your virtual infrastructure. When CPU usage exceeds certain thresholds, additional VMs are started. Conversely, when CPU usage drops below defined levels, instances are stopped to conserve resources.

-  **GCP VM Monitoring**: This Bash script monitors CPU usage across all running Google Cloud VM instances whose names contain the word servidor(feel free to change it to whatever you need!). It retrieves the CPU usage, calculates the average CPU usage across all matching instances, and logs the results.

-  **Postgre Automatic Backups**: This script provides a Dockerized solution for automating PostgreSQL database backups. The backup script runs inside a Docker container and creates compressed, encrypted backups, which are stored locally. The solution also manages backup retention, deleting old backups based on the specified number of days.

## Liability

All scripts provided in this repository are as-is and you use them at your own risk.

## LICENSE

This collection of bash scripts is licensed under the [MIT License](LICENSE). Use it at your own risk.
