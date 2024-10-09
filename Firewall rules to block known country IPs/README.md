
# Firewall rules to block known country IPs

I developed this script as part of my final degree project. One of the project components required us to set up firewall rules for each of our VMs, to demonstrate that we understood how to do it. 

I decided that simple rules were not enough. Through [Project Honey Pot](https://www.projecthoneypot.org), I identified which countries were responsible for the most attacks. I then found a database containing IPv4 and IPv6 addresses from these countries and created this script, which essentially generates IPSets for them. This allowed me to create firewall rules that block incoming and outgoing traffic from these IP addresses.

Ideally you would access [MaxMind's GeoLite2 database](https://www.maxmind.com/en/geoip-api-web-services?gad_source=1&gclid=Cj0KCQjwsJO4BhDoARIsADDv4vA3BoUMoVjSvqdISqbFYa6AbnOgwnAS2N39l8JGjReF90jN6uhP6tcaAld_EALw_wcB) and regularly download the most recent databases. However, since that required a paid subscription, I simply used the free ones available at their website. 

## How to run the scripts

First things first, you need to add execution permissions to all scripts of course:


```bash
chmod +x dependencies.sh
chmod +x create_ipsets.sh
chmod +x create_rules.sh
```


## dependencies.sh

The **dependencies.sh** script, as the name suggests, installs the necessary dependencies: 

- ipset
- iptables-persistent
- iptables

## create_ipsets.sh

The **create_ipsets.sh** script is responsible for, as the name suggests, creating the IPSets. 

### Key Features
- Country-based IP set creation: Creates IP sets for the selected countries using ISO 3166-1 alpha-2 codes (e.g., "CN" for China, "US" for the United States).
- IP range filtering: Filters IP ranges for each country using GeoLite2 databases.
- Supports both IPv4 and IPv6: Reads from CSV files containing IPv4 and IPv6 address blocks.

According to the Project Honeypot, the countries responsible for most of the attacks were: 

- CN: China
- US: United States
- ES: Spain
- IN: India
- GB: United Kingdom (Great Britain)
- RU: Russia
- BR: Brazil
- VN: Vietnam
- UA: Ukraine

You can modify the COUNTRIES array in the script to include or remove countries as needed.

### Prerequisites:

 **GeoLite2 Databases**: Ensure that you have the following CSV files in the same directory as the script:

- GeoLite2-Country-Blocks-IPv4.csv: Contains IPv4 address blocks.
- GeoLite2-Country-Blocks-IPv6.csv: Contains IPv6 address blocks.
- GeoLite2-Country-Locations-en.csv: Maps countries to their GeoLite2 geoname IDs.

These files can be obtained from [MaxMind's GeoLite2 database](https://www.maxmind.com/en/geoip-api-web-services?gad_source=1&gclid=Cj0KCQjwsJO4BhDoARIsADDv4vA3BoUMoVjSvqdISqbFYa6AbnOgwnAS2N39l8JGjReF90jN6uhP6tcaAld_EALw_wcB) but I also included them in this repo.

### How the script works

1. Check for Required Files:
The script first checks if the required GeoLite2 CSV files (GeoLite2-Country-Blocks-IPv4.csv, GeoLite2-Country-Blocks-IPv6.csv, and GeoLite2-Country-Locations-en.csv) are present. If they are missing, the script exits with an error.

2. Create Temporary Directory:
A temporary directory is created to store intermediate files. This directory is cleaned up at the end.

3. Map Country Codes to GeoLite2 IDs:
The script reads from GeoLite2-Country-Locations-en.csv and maps the country ISO codes (e.g., "CN" for China) to the corresponding geoname_id used by GeoLite2. These IDs are stored in an associative array (COUNTRY_IDS).

4. Create IP Sets:
For each country in the COUNTRIES array, the script creates an ipset named country_<ISO_CODE> (e.g., country_CN for China).

5. Populate IP Sets with IP Ranges:
The function add_ip_ranges_to_ipset reads the IP ranges from the IPv4 and IPv6 CSV files and adds the relevant ranges to each country's IP set using the ipset add command.

6. Clean Up:
The temporary directory is deleted once the IP sets are populated, and the script outputs a confirmation message: "IP sets created and populated."

**NOTE: THIS SCRIPT TAKES A WHILE TO RUN, IT IS NORMAL!**

## create_rules.sh

This script creates firewall rules using iptables to block both **incoming** and **outgoing traffic** from a predefined set of countries. It uses the IP sets that were created in the earlier script (e.g., country_CN for China) and adds rules to the INPUT and OUTPUT chains of iptables, effectively preventing communication with the specified countries.

### Key Features

- Blocks incoming traffic: Prevents traffic from IP addresses within the specified countries from reaching the system.
- Blocks outgoing traffic: Prevents traffic from your system from reaching IP addresses within the specified countries.
- Easy to modify: You can adjust the list of countries by editing the COUNTRIES array.


--- 

