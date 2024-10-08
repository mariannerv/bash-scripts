#!/bin/bash

COUNTRIES=("CN" "US" "ES" "IN" "GB" "RU" "BR" "VN" "UA")

BLOCKS_IPV4="GeoLite2-Country-Blocks-IPv4.csv"
BLOCKS_IPV6="GeoLite2-Country-Blocks-IPv6.csv"
LOCATIONS="GeoLite2-Country-Locations-en.csv"

if [ ! -f "$BLOCKS_IPV4" ] || [ ! -f "$BLOCKS_IPV6" ] || [ ! -f "$LOCATIONS" ]; then
    echo "CSV files not found. Please check the paths."
    exit 1
fi

TEMP_DIR="/tmp/ipset_temp"
mkdir -p $TEMP_DIR


declare -A COUNTRY_IDS
while IFS=',' read -r geoname_id locale_code continent_code continent_name country_iso_code country_name is_in_european_union; do
    if [[ " ${COUNTRIES[@]} " =~ " $country_iso_code " ]]; then
        COUNTRY_IDS[$country_iso_code]=$geoname_id
    fi
done < <(tail -n +2 $LOCATIONS)


add_ip_ranges_to_ipset() {
    local csv_file=$1
    while IFS=',' read -r network geoname_id _; do
        for country in "${!COUNTRY_IDS[@]}"; do
            if [[ "${COUNTRY_IDS[$country]}" == "$geoname_id" ]]; then
                sudo ipset add country_$country $network -exist
            fi
        done
    done < <(tail -n +2 $csv_file)
}


for COUNTRY in "${COUNTRIES[@]}"; do
    sudo ipset create country_$COUNTRY hash:net -exist
done


add_ip_ranges_to_ipset $BLOCKS_IPV4
add_ip_ranges_to_ipset $BLOCKS_IPV6


rm -rf $TEMP_DIR

echo "IP sets created and populated."
