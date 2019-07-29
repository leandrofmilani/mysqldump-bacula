# mysqldump-bacula
Dump all MySQL databases before a bacula job execute

---

This script was designed for executing directly from the machine where is located in the database.

I recommend to create a user just with the permissions to get the dump, for example:
```mysql
CREATE USER 'backup'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, EXECUTE, PROCESS, SHOW VIEW, EVENT, TRIGGER ON *.* TO 'backup'@'localhost';
```
This command will create a user called backup and grant the permissions need to dump all databases from your server.


Then in the bacula server, you should configure the job adding the following line:
```
Client Run Before Job = "/path/to/script/backupMySQL.sh"
```
The path is where the script is located in the machine that this job is set.

This way the bacula will execute the script and when finish will backup the directories from the server.
