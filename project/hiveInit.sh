#!/bin/bash

# Only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

cd /home/student/share/project

sqoop import-all-tables --connect jdbc:postgresql://localhost:5432/Adventureworks --username student --password foobar --outdir hive --bindir hive --warehouse-dir hive/warehouse --hive-import --hive-overwrite -- --schema=rolap