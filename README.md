# dw-project

## 1 - Operational data sources inspection and proling

To import the data I wrote the initDb.sh script.

The script streamlines the database initialization process and solves the following error I have encountered:

- the database "student" may not exist in postgres. If it does not exist, it is created.

- some CSV files contained some empty lines that gave errors when imported by Postgres. The empty lines are therefore removed

- the EOLs of the CVS files were CTRLF. This may be a problem on the linux server. I coverted the EOLS of the files to LF. 

- the AdventureworksDb.sql file imports the files using the space as a separator, while the values in the CSV files are separated by Tabs. I fixed the sql script. 