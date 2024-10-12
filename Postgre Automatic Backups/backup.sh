#!/bin/bash

# If all arguments are not provided
if [ "$#" -ne 6 ]; then
    echo "Usage: $0 <db_host> <db_port> <db_user> <db_password> <db_name> <retention_days>"
    exit 1
fi

#------------------------------Variables------------------------------------------#
DB_HOST=$1
DB_PORT=$2
DB_USER=$3
DB_PASSWORD=$4
DB_NAME=$5
RETENTION_DAYS=$6
BACKUP_DIR="/mnt/backups"  # Directory where backups will be stored
DATE=$(date +'%Y-%m-%d_%H%M')
BACKUP_FILE="${BACKUP_DIR}/db-backup-${DATE}.sql"  # Backup file itself
#--------------------------------------------------------------------------------#


export PGPASSWORD=$DB_PASSWORD  # To avoid asking for password every time the script runs

# The script first tries to connect to the database to ensure it exists, if not, it returns an error
if ! psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c '\q'; then
    echo "Error: The database '$DB_NAME' does not exist or is not accessible."
    exit 1
fi

# Run the PostgreSQL command to make the backup, only if the connection is successful
echo "Creating a backup of the database..."
pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -F c -b -v -f "$BACKUP_FILE" "$DB_NAME"

if [ $? -eq 0 ]; then

    # Compress the .sql file into a zip
    ZIP_FILE="${BACKUP_FILE}.zip"
    echo "Compressing the backup file to: $ZIP_FILE"
    zip -e -P "$DB_PASSWORD" "$ZIP_FILE" "$BACKUP_FILE"  # For simplicity, the password used to encrypt the zip is the same as the DB password

    if [ $? -eq 0 ]; then
        rm "$BACKUP_FILE"  # Remove the .sql file after compression
        echo "Backup completed and compressed successfully: $ZIP_FILE"
    else
        echo "Something went wrong during the file compression."
        exit 1
    fi

    # At 03:00 AM, clean up backups older than the retention period
    if [ "$(date +'%H%M')" == "0300" ]; then
        echo "Deleting backups older than $RETENTION_DAYS days..."
        find "$BACKUP_DIR" -name "db-backup-*.zip" -mtime +$RETENTION_DAYS -exec rm {} \;  # Search and remove all backups older than the retention period
    fi

else
    echo "Something went wrong while creating the backup."
    exit 1
fi
