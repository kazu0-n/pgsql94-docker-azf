#!/bin/sh -eu

ENV_FILE=/etc/sysconfig/postgres_env

DB_NAME=$(curl -s https://your-host-name/env/DB_NAME.txt)
DB_PASS=$(curl -s https://your-host-name/env/DB_PASS.txt)
DB_USER=$(curl -s https://your-host-name/env/DB_USER.txt)

DBENV="DB_NAME=$DB_NAME\nDB_PASS=$DB_PASS\nDB_USER=$DB_USER"
echo -e $DBENV > $ENV_FILE