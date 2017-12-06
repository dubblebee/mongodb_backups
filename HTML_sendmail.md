# Send HTML emails using sendmail

cat <<'EOF' - ~/workspace/mongodb/email/failure-notification.html | /usr/sbin/sendmail -t
To: brian.benton@bbc.co.uk
Subject: MongoDB test msg
Content-Type: text/html

EOF

# Mailx
echo "*** Backup complete - Added $DEST ***" | mail -v -s "$HOSTNAME - MongoDB backup & delete" brian.benton@bbc.co.uk
or
cat $LOG | mail -s "$HOST/$DB mongo archive & delete" -r ${FROM} ${MAILTO}