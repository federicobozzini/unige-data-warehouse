#!/bin/bash

echo 'Fixing file formatting issues'
mkdir -p ./dbData
cp ./AdventureWorksDB/*.csv ./dbData
find ./dbData -type f -name "*.csv" -exec sed -i 's/.$//' {} \;
find ./dbData -type f -name "*.csv" -exec sed -i '/^$/d' {} \;
cp AdventureWorksDB.sql dbInit.sql
sed -i "s/DELIMITER '\s'/DELIMITER E'\\t'/g" dbInit.sql
echo 'Importing the data'
echo creating the db student if necessary
createdb student 2> /dev/null
psql -U student -c "DROP DATABASE IF EXISTS \"Adventureworks\";"
psql -U student -c "CREATE DATABASE \"Adventureworks\";"
cd dbData
psql -d Adventureworks < ../dbInit.sql