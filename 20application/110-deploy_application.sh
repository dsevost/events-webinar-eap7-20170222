#!/bin/bash

EXTIP=$(ip ro get 8.8.8.8 |awk '/8.8.8.8.*via.*src/ { print $7; }')
CONTROLLER_HOST=${CONTROLLER_HOST:-$EXTIP}

dir1=$(realpath $(dirname $0))

set -ex

#mvn wildfly:deploy -Dhostname=$CONTROLLER_HOST
mvn clean package -f ${dir1}/helloworld

~/app/eap-7/bin/jboss-cli.sh --connect --controller=$CONTROLLER_HOST \
    --command="deploy --server-groups=example-server-group $dir1/helloworld/target/helloworld.war"

~/app/eap-7/bin/jboss-cli.sh --connect --controller=$CONTROLLER_HOST \
    --commands="\
    /profile=proxy/subsystem=undertow/configuration=handler/reverse-proxy=helloworld-proxy/host=helloworld-host1:add( \
	outbound-socket-binding=remote-host1, scheme=ajp, instance-id=helloworld-route, path=/helloworld), \

    /profile=proxy/subsystem=undertow/configuration=handler/reverse-proxy=helloworld-proxy/host=helloworld-host2:add( \
	outbound-socket-binding=remote-host2, scheme=ajp, instance-id=helloworld-route, path=/helloworld), \

    /profile=proxy/subsystem=undertow/configuration=handler/reverse-proxy=helloworld-proxy/host=helloworld-host3:add( \
	outbound-socket-binding=remote-host3, scheme=ajp, instance-id=helloworld-route, path=/helloworld), \

    /profile=proxy/subsystem=undertow/server=default-server/host=default-host/location=\/helloworld:add(handler=helloworld-proxy) \
    "
