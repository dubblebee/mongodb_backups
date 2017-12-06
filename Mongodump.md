##MongoDB Backup using mongodump

#Mongodump with SSL
$./mongodump --ssl --sslCAFile <path/to-cert-file.pem> --sslPEMKeyPassword password123 --host <hostname>:27017 --out /mongo_data/backup/ # <-- or other backup


#Mongodump without SSL
$ ./mongodump --host <hostname> --port 27017 --username=mongo --password=mongo --out /data/backup/ # <-- or other backup

/usr/bin/mongodump --host localhost --port 27017 --username=mongo --password=mongo --out /data/backup/