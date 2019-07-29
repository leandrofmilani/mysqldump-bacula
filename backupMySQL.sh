#!/bin/bash
## Backup MySQL databases (use for bacula)
## Leandro Fabris Milani
## Jul 2019

## MySQL user for backups
#	CREATE USER 'backup'@'localhost' IDENTIFIED BY 'password';
#	GRANT SELECT, EXECUTE, PROCESS, SHOW VIEW, EVENT, TRIGGER ON *.* TO 'backup'@'localhost';

userMysql="backup"
export MYSQL_PWD="password"
dateBackup="$(date +%d-%m-%y_%H_%M)"
backupName="backupDatabases_$dateBackup"
backupFolder="/root/BackupMySQL/"
saveDirectory="$backupFolder$backupName"
rmOldBackups=$backupFolder"*.tar.gz"

#Remove old backups
rm $rmOldBackups

#Export list of databases
databaseList=`mysql -u $userMysql -N -B -e "show databases;"`
for database in $databaseList; do
	#Create folder for each database
	databaseFolder="$saveDirectory/$database"
	mkdir -p $databaseFolder
	#Export list of tables
	tableList=`mysql -u $userMysql -N -B -e "show tables from $database;"`
	for table in $tableList; do
		#Execute the dump for table
		mysqldump -u $userMysql --quick --skip-events --ignore-table=mysql.event --single-transaction --lock-tables=false "$database" "$table" > $databaseFolder/$table.sql
	done
	#Compact folder
	cd $saveDirectory
	tar -zcf "$database.tar.gz" $database
	rm -rf $database
done

#Compact all folder and delete compacted files of each database
cd $backupFolder
tar -zcf $backupName.tar.gz $backupName
rm -rf $saveDirectory

exit 0