#!/bin/bash

EXTIP=$(ip ro get 8.8.8.8 |awk '/8.8.8.8.*via.*src/ { print $7; }')
CONTROLLER_HOST=${CONTROLLER_HOST:-$EXTIP}

dir1=$(realpath $(dirname $0))

pushd ${dir1}

set -x

~/jboss-forge/bin/forge -e "run ${dir1}/forge-helloworld.fsh"
