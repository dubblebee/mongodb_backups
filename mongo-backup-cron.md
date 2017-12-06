> sudo -u mongod crontab -e

# MongoDB Backups - run every 2 hours starting at 00:00
0 */2 * * * /var/scripts/backup/mongo-backup.sh