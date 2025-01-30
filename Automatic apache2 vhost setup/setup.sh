#!/bin/bash
#check for correct usage of the arguments
if [ "$#" -lt 1 ]; then
        echo "Usage: ./script.sh yourdomain"
        exit 1
fi

#check if apache is installed
if command -v apache2 &> /dev/null; then
        echo "Apache is installed. Continuing configuration..."
else
        read -p "Apache is not installed. Would you like to install it? (y/n)" choice
        case $choice in
        [yY]*) sudo apt install apache2;;
        [nN]*) echo "Exiting..."; exit;;
        *) exit;;
        esac
fi

domain=$1
echo "Setting up Apache2 for domain: $domain"

#Configure apache file
sudo tee /etc/apache2/sites-available/$domain.conf > /dev/null <<EOF
<VirtualHost *:80>
        ServerAdmin webmaster@$domain
        ServerName $domain
        ServerAlias www.$domain
        DocumentRoot /var/www/$domain
        ErrorLog /var/log/apache2/$domain_error.log
        CustomLog /var/log/apache2/$domain_access.log combined
</VirtualHost>
EOF


sudo mkdir -p /var/www/$domain
sudo chown -R $USER:$USER /var/www/$domain
sudo chmod -R 755 /var/www

#enable virtual host file
sudo a2ensite $domain.conf
sudo a2dissite 000-default.conf
sudo systemctl restart apache2

echo "Apache2 setup complete for domain: $domain"
