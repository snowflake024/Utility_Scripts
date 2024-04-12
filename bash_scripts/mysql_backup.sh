#!/bin/bash

# MySQL Credentials
MYSQL_USER="root"
MYSQL_PASSWORD=""

# Backup directory
BACKUP_DIR="/srv/backups"

# Date format for backup file names
DATE=$(date +"%Y%m%d_%H%M%S")

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Get list of databases
databases=$(mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)")

# Backup each database
for db in $databases; do
    mysqldump -u$MYSQL_USER -p$MYSQL_PASSWORD --single-transaction --routines --triggers --databases $db > $BACKUP_DIR/$db-$DATE.sql
    gzip $BACKUP_DIR/$db-$DATE.sql
done

echo "All databases backed up successfully to $BACKUP_DIR"
