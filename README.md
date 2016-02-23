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
* azfenv.service
