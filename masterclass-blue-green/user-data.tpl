#!/bin/bash

#get app
wget https://github.com/0rc/go-postgres-example/releases/download/${app_version}/go-postgres-example.tar.gz
tar xzf go-postgres-example.tar.gz

#create db
yum -y install postgresql96.x86_64
PGPASSWORD=${db_pass} psql -h${db_host} -U${db_user} ${db_name} < data.sql

#run app
DB_HOST=${db_host} DB_USER=${db_user} DB_PASS=${db_pass} DB_NAME=${db_name} ./go-postgres-example &
