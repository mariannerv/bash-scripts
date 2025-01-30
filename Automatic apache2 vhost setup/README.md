# Apache2 Virtual Host Setup Script

## Overview

This script automates the process of setting up a new Apache2 virtual host. It creates the necessary configuration file, sets up the document root, and enables the site, ensuring that the domain is correctly configured.

## Features

- **Automatic Virtual Host Configuration**: Generates and configures the Apache2 virtual host file for the specified domain.
- **Domain-Specific Logging**: Creates individual log files for each virtual host to facilitate troubleshooting.
- **Directory Setup**: Automatically creates the required directory structure with proper permissions.
- **Apache2 Service Management**: Enables the new virtual host and restarts the Apache2 service.

## Prerequisites

- A Linux system with Apache2 installed (Debian-based distributions recommended).
- Root or sudo privileges to modify Apache2 configurations.

## Usage

1. Ensure the script is executable:

```bash
chmod +x setup.sh
```

2. Run the script with your domain name as an argument:

```bash
./setup.sh yourdomain.com
```

## Script Behavior

- **Apache2 Check**: Verifies if Apache2 is installed. If not, prompts the user to install it.
- **Configuration File Creation**: Creates a virtual host configuration file under `/etc/apache2/sites-available/`.
- **Directory Setup**: Ensures `/var/www/yourdomain.com` exists with the correct ownership and permissions.
- **Enabling Site**: Activates the new virtual host and disables the default site.
- **Restarting Apache2**: Applies the new configuration by restarting the service.

## Example

To set up a virtual host for `example.com`, run:

```bash
./setup.sh example.com
```

The virtual host will be available at `/var/www/example.com`, and its logs will be stored in `/var/log/apache2/`.

## Notes

- Ensure that the domain's DNS is correctly configured to point to your server.
- The script assumes the use of the default Apache2 installation on Debian-based systems.
- If Apache2 does not restart successfully, check the syntax of the configuration file using:

```bash
apachectl configtest
```

