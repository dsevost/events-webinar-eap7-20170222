#!/bin/bash

EXTIP=$(ip ro get 8.8.8.8 |awk '/8.8.8.8.*via.*src/ { print $7; }')
CONTROLLER_HOST=${CONTROLLER_HOST:-$EXTIP}

dir1=$(realpath $(dirname $0))

set -x

~/app/eap-7/bin/jboss-cli.sh --connect --controller=$CONTROLLER_HOST --file=${dir1}/create-webinar_configuration.cli
