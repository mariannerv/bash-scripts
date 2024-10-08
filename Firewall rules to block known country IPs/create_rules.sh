COUNTRIES=("CN" "US" "ES" "IN" "GB" "RU" "BR" "VN" "UA")
for COUNTRY in "${COUNTRIES[@]}"; do
    sudo iptables -A INPUT -m set --match-set country_$COUNTRY src -j DROP
    sudo iptables -A OUTPUT -m set --match-set country_$COUNTRY dst -j DROP
done