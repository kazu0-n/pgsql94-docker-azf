#!/bin/bash

psql -U postgres --command "CREATE USER ${DB_USER} WITH CREATEDB PASSWORD '${DB_PASS}';"
psql -U postgres --command "CREATE DATABASE ${DB_NAME} OWNER ${DB_USER} TEMPLATE template0;"

mkdir /mnt/pgsql/archive
