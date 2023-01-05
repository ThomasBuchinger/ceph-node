#!/bin/bash

CONFIG_FILE=.config.source
SECRETS_FILE=.secrets.source

touch $CONFIG_FILE $SECRETS_FILE
if ! grep "NODE_IP=" $CONFIG_FILE; then
  echo -n Finding IP address....
  echo "NODE_IP=$(ip route get 8.8.8.8 | grep -oe 'src.*'  | cut -d ' ' -f2)" >> $CONFIG_FILE
  echo ok
fi

if ! grep "DASHBOARD_PASSWORD=" $SECRETS_FILE; then
  read -p "Enter Dashboard Password: " pass
  echo "DASHBOARD_PASSWORD=$pass" >> $SECRETS_FILE
fi



