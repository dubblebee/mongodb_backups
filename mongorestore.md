# Mongorestore

# With SSL
./mongorestore --ssl --sslCAFile ../cert/mongo.server.trust-certs.pem --sslPEMKeyPassword password123 --host pre-mongo01.ibmcloud.com:27017 --db testdb1 /mongo_data/backup/testdb1

# Without SSL
/usr/bin/mongorestore --host localhost:27017 --username=admin --password=admin123 --authenticationDatabase admin --db test /data/backup/2017-11-07-10:40:59/test