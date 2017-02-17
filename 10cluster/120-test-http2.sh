#!/bin/bash

EXTIP=$(ip ro get 8.8.8.8 |awk '/8.8.8.8.*via.*src/ { print $7; }')
CONTROLLER_HOST=${CONTROLLER_HOST:-$EXTIP}

curl http://$CONTROLLER_HOST:8080/cluster-test-webapp/ 2>/dev/null|awk '/Local server name/'
