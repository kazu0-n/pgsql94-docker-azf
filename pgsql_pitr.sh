#!/bin/bash -eu

/usr/bin/pg_basebackup -D /mnt/pgsql/backup
/bin/mv /mnt/pgsql/backup/ /mnt/pgsql/backup`date +%Y%m%d`
/usr/bin/find /mnt/pgsql/archive/ -type f -mtime +3 -exec rm -f {} \;
/usr/bin/find /mnt/pgsql/* -maxdepth 0 -type d -mtime +3 ! -name archive -exec rm -rf {} \;