#!/bin/bash -xe

/usr/bin/sed -i 's/listeners=.*/listeners=PLAINTEXT:\/\/kafka--${env}-${env-number}.${dns_domain}:9092/g' \
  /opt/kafka/config/server.properties
