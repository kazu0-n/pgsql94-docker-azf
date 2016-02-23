Files are in connection with pgsql 9.4 docker container
======================
##Outline
This container image is mounting the Azure File Storage for Point in time recovery(PITR).

The container uses systemd to control processes.
It consists of multiple files shell script and systemd unit.

####Building  container image
```
# docker build --rm -t pgsql94:image-version-no .
```
####Running container
*This image controls processes using systemd. So it's necessary to use privileged mode.
```
# docker run -i -t -d --name=pgsql94 --privileged -p 5432:5432 pgsql94:image-version-no
```
####Explanation for systemd unit files and execution Shell script
- Shell script to acquire certification information.
 - azfenv.sh 
 - postgres_env.sh
These scripts get information from webserver provides credential data.
I recommend that I set a limit to access to admit it only from a container host server.
When you use it, please transfer "your-host-name" to your complete URL.

- azfenv.service
The systed unit makes credential file "/etc/sysconfig/azfile_env" for "mnt-pgsql.mount" unit with "azfenv.sh".
 
- createdb.service
The systemd unit makes databese and user role for AP Server Databese.
This unit set to carry out only once at the time of the first start
 - stop_createdb.sh
 This script sets unit oneself for a stop 

- mnt-pgsql.mount
The systemd unit mount Azure File Storage.

- pgsql_pitr.service 
The systemd unit which carries out PITR backup in the folder which Azure File Storage was mounted behind
 - pgsql_pitr.sh
   The script stores backup for "/mnt/pgsql/ backup" and adds a postscript to a date for a folder name
   It deletes a archive file and the base backup folder that was made before 3days.

 - pgsql_pitr.timer
   The timer unit is set to carry it out once a day.
   It synchronize automatically by matching the name of the timer unit with a service unit.
