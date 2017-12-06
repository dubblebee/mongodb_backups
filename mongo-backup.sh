#!/usr/bin/env bash

# Assign variables & set-up files
WKDIR=/data/backup
DIR=`date +%F-%T`
DEST=/data/backup/$DIR
ERR='zz_FAILED_BACKUP_'$DIR
LOG=/data/backup_logs/backup.log
REMLOG=/data/backup_logs/removed.log

echo "MongoDB backup process started..."

# Make copies of the email templates for editing
cp /var/scripts/backup/email/success-template.html /var/scripts/backup/email/success-notification.html
cp /var/scripts/backup/email/failure-template.html /var/scripts/backup/email/failure-notification.html

# Create the backup folder
mkdir $DEST
# Run mongodump - backup all databases
/usr/bin/mongodump --host localhost --port 27017 --username=admin --password=anORgdGl67mWJAowR6VqIfzdQi52AlbB --authenticationDatabase=admin --out $DEST \
>> $LOG 2>&1


# Error catching & notification
if [ $? -ne 0 ]; then
    # Move & rename the failed backup folder
    mv $DEST /data/failed_backup/$ERR

    # Capture the error message
    failmsg=$(tail -1 /data/backup_logs/backup.log)
    
    # Log the events
    echo "*** MongoDump failed! ***" | tee -a "$LOG"

    # Send email notification of failure
    sed -i -e "s~%%FAILURE%%~${failmsg}~g" /var/scripts/backup/email/failure-notification.html
    
    # Do NOT indent Email headers & EOF below
    cat <<'EOF' - /var/scripts/backup/email/failure-notification.html | /usr/sbin/sendmail -i -t
To: brian.benton@bbc.co.uk
Subject: MongoDB Backup failed
Content-Type: text/html

EOF
    
    exit 1
else
	# Log the events
	echo "*** Backup complete - Added $DEST ***"  | tee -a "$LOG"

    # Remove the oldest backup folder
    min_dirs=3
	[[ $(find "$WKDIR" -maxdepth 1 -type d | wc -l) -ge $min_dirs ]] &&
	IFS= read -r -d $'\0' line < <(find "$WKDIR" -maxdepth 1 -printf '%T@ %p\0' 2>/dev/null | sort -z -n)
	file="${line#* }"
	echo "REMOVED " $file &>> $REMLOG
    remdir=$file
	rm -rf "$file"
    
    
    # Send email notification of success
    sed -i -e "s~%%ADDED%%~${DIR}~g" -e "s~%%REMOVED%%~${remdir}~g" /var/scripts/backup/email/success-notification.html

    # echo $NEWDIR
    # echo $REMDIR
    
    # Do NOT indent Email headers & EOF below
    cat <<'EOF' - /var/scripts/backup/email/success-notification.html | /usr/sbin/sendmail -i -t
To: brian.benton@bbc.co.uk
Subject: MongoDB Backup completed
Content-Type: text/html

EOF

fi

# Make an archive copy of the backup.log file
cp /data/backup_logs/backup.log /data/backup_logs/${DIR}_backup.log