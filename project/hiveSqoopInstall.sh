#!/bin/bash

# Only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt-get update
yes | apt-get install wget
wget http://public-repo-1.hortonworks.com/HDP/debian7/2.x/updates/2.4.2.0/hdp.list -O /etc/apt/sources.list.d/hdp.list
apt-get update
yes | apt-get install sqoop
curl -L "https://jdbc.postgresql.org/download/postgresql-42.0.0.jar" -o postgresql-connector.jar
mv postgresql-connector.jar /var/lib/sqoop/
ln -s /var/lib/sqoop/postgresql-connector.jar /usr/hdp/current/sqoop-client/lib/postgresql-connector.jar