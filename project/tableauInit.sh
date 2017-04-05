#!/bin/bash

# Only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.6/main/pg_hba.conf

echo "listen_addresses='*'" >> /etc/postgresql/9.6/main/postgresql.conf

/etc/init.d/postgresql restart
