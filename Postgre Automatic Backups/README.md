
# PostgreSQL Automatic Backup Solution
## Introduction

This project provides a Dockerized solution for automating PostgreSQL database backups. The backup script runs inside a Docker container and creates compressed, encrypted backups, which are stored locally. The solution also manages backup retention, deleting old backups based on the specified number of days.

## Requirements

- Docker installed on your system;
- A running PostgreSQL database instance;

## Setup instructions

1. **Clone the Repository**

```bash
git clone <repository-url>
cd <repository-directory>
```

2. **Build the Docker Image**

The Dockerfile sets up the environment needed to run the backup script. To build the Docker image, run (you can change ``db-backup-image`` to whatever you want):

```bash
docker build -t db-backup-image .
```

This command builds a Docker image with the necessary dependencies (PostgreSQL client, cron, etc.) and copies the backup script into the container.

3. **Running the Container**

Once the image is built, you can create and run the Docker container. The container will schedule backups at 03:00 AM and 14:00 PM (UTC) every day, and manage retention based on the number of days you specify.

Run the container with the following command:

```bash
docker run -d --name db-backup-container \
    -e DB_HOST=your_db_host \
    -e DB_PORT=your_db_port \
    -e DB_USER=your_db_user \
    -e DB_PASSWORD=your_db_password \
    -e DB_NAME=your_db_name \
    -e RETENTION_DAYS=5 \
    db-backup-image

```

Replace the following placeholders:

``your_db_host`` : The IP or hostname of your PostgreSQL database.
``your_db_port`` : The port of the PostgreSQL database (default is 5432).  
``your_db_user`` : The username to connect to the database.
``your_db_password`` : The password to connect to the database.
``your_db_name`` : The name of the database you want to back up.
``RETENTION_DAYS`` : The number of days to keep backups before deleting them.

## Script Overview

The backup script performs the following tasks:

1. Connects to the PostgreSQL database to ensure it's accessible.
2. Performs a backup using pg_dump, saving the backup in /mnt/backups with a filename prefixed by the date and time.
3. Compresses the backup into a .tar.gz archive and encrypts it using the database password.
4. Deletes old backups during the 03:00 AM run if they are older than the specified retention period (in days).

## Usage

You can run the script manually inside the container with:

```bash
/script.sh $DB_HOST $DB_PORT $DB_USER $DB_PASSWORD $DB_NAME $RETENTION_DAYS
```

For example:

```bash
/script.sh postgres_db123 5432 postdb_user post123 post_db 5
```

## Scheduling with Cron
The Docker container is configured to use cron to run the backup script twice a day:

- At **03:00 AM UTC**
- At **14:00 PM UTC**


These jobs are automatically set up using the environment variables passed when running the container.

If you'd like to change the schedule, you can modify the ``cron`` settings in the Dockerfile or manually inside the container by editing the cron job using ``crontab -e``.


## Cleanup and Backup Retention

Backups older than the specified number of days (``RETENTION_DAYS``) are automatically deleted at 03:00 AM during the backup process. You can adjust the retention period by setting a different value for ``RETENTION_DAYS`` when running the container.


## Security Considerations

- **Database Password**: The PostgreSQL password is passed as an environment variable and used to both connect to the database and encrypt the backup files. Be cautious when handling sensitive information in production environments.


## Conclusion
This solution automates the backup of PostgreSQL databases inside a Docker container, providing secure, compressed backups and managing retention based on a specified number of days. By leveraging Docker and cron, this solution is easy to deploy, maintain, and scale.