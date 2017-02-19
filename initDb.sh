#!/bin/bash

cd AdventureworksDB
# This may be necessary
# createdb student
psql -U student -c "DROP DATABASE IF EXISTS \"Adventureworks\";"
psql -U student -c "CREATE DATABASE \"Adventureworks\";"
psql -d Adventureworks < ../AdventureworksDB.sql