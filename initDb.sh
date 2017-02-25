#!/bin/bash

echo 'Fixing file formatting issues'
find ./AdventureWorksDB -type f -name "*.csv" -exec sed -i 's/.$//' {} \;
find ./AdventureWorksDB -type f -name "*.csv" -exec sed -i '/^$/d' {} \;
sed -i "s/DELIMITER '\s'/DELIMITER E'\\t'/g" AdventureWorksDB.sql
cd AdventureworksDB
echo 'Importing the data'
# This may be necessary
# createdb student
psql -U student -c "DROP DATABASE IF EXISTS \"Adventureworks\";"
psql -U student -c "CREATE DATABASE \"Adventureworks\";"
psql -d Adventureworks < ../AdventureworksDB.sql