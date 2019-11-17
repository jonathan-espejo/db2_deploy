#!/bin/bash -ex

cd /tmp

gunzip v11.1.4fp4a_linuxx64_server_t.tar.gz
tar -xvf v11.1.4fp4a_linuxx64_server_t.tar

sleep 5
cd server_t

sudo ./db2_install -p SERVER  -b /opt/ibm/db2/V11.1 -f NOTSAMP -c /tmp/db2_t/db2 -n -y -l db2install.log

sleep 5
# Create DB2 instance
sudo su -c "/opt/ibm/db2/V11.1/instance/db2icrt -u d01scvf1 d01scvi1"

#start database server

sudo chown -R dbadmin.db2adm /db/DBSPACE001
sudo chown -R dbadmin.db2adm /db/WKSPACE001
sudo chown -R dbadmin.db2adm /db/LGSPACEA01
sudo chown -R dbadmin.db2adm /db/dbpath
sudo chown -R dbadmin.db2adm /db/dbadmin
sudo chown -R dbadmin.db2adm /db/dump

sudo chmod g+w /db/dbpath
sudo chmod g+w /db/DBSPACE001
sudo chmod g+w /db/LGSPACEA01
sudo chmod g+w /db/WKSPACE001
sudo chmod g+w /db/dbadmin
sudo chmod g+w /db/dbpath


sudo su - d01awsi1

db2start

ps -ef | grep db2sysc


# Apply DBM config

#Create DB2 database

sleep 5

db2 -tvf /tmp/createdb.sql

#Apply DB config

#DB deployment will be done as a separate step in Jenkins
#Launch EC2 instance and run db deployment

#Deploy DDL
#Load database