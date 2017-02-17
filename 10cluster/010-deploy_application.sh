#!/bin/bash

EXTIP=$(ip ro get 8.8.8.8 |awk '/8.8.8.8.*via.*src/ { print $7; }')
CONTROLLER_HOST=${CONTROLLER_HOST:-$EXTIP}

dir1=$(realpath $(dirname $0))

set -ex

#mvn wildfly:deploy -Dhostname=$CONTROLLER_HOST
mvn clean package -f cluster-test-webapp

~/app/eap-7/bin/jboss-cli.sh --connect --controller=$CONTROLLER_HOST \
    --command="deploy --server-groups=example-server-group $dir1/cluster-test-webapp/target/cluster-test-webapp.war"

~/app/eap-7/bin/jboss-cli.sh --connect --controller=$CONTROLLER_HOST \
    --commands="\
    /profile=proxy/subsystem=undertow/configuration=handler/reverse-proxy=webinar-proxy/host=cluster-test-webapp-host1:add( \
	outbound-socket-binding=remote-host1, scheme=ajp, instance-id=cluster-route, path=/cluster-test-webapp), \
    /profile=proxy/subsystem=undertow/configuration=handler/reverse-proxy=webinar-proxy/host=cluster-test-webapp-host2:add( \
	outbound-socket-binding=remote-host2, scheme=ajp, instance-id=cluster-route, path=/cluster-test-webapp), \
    /profile=proxy/subsystem=undertow/configuration=handler/reverse-proxy=webinar-proxy/host=cluster-test-webapp-host3:add( \
	outbound-socket-binding=remote-host3, scheme=ajp, instance-id=cluster-route, path=/cluster-test-webapp), \
    /profile=proxy/subsystem=undertow/server=default-server/host=default-host/location=\/cluster-test-webapp:add(handler=webinar-proxy) \
    "