#!/bin/bash

EAP_TYPE=${EAP_TYPE:-"domain"}
DOMAIN_NAME=${DOMAIN_NAME:-"webinar-eap7"}
#CONTROLLER_HOST=${CONTROLLER_HOST:-127.1.0.10}
EXTIP=$(ip ro get 8.8.8.8 |awk '/8.8.8.8.*via.*src/ { print $7; }')
CONTROLLER_HOST=${CONTROLLER_HOST:-$EXTIP}

dir1=$(realpath $(dirname $0))

set -x

function create_host() {
    [ -z "$1" ] && { echo "Syntax: create_host <host_name>" ; exit 1; }

    local host_dir=$EAP_HOME/../$DOMAIN_NAME/$1
    if ! [ -d "$host_dir" ] ; then
	mkdir -p "$host_dir"
	tar -C $EAP_HOME/$EAP_TYPE -cf - . | tar -C $host_dir -xf - || exit 1
    fi
}

function start_host() {
    [ -z "$1" ] && { echo "Syntax: start_host <host_name>" ; exit 1; }

    local host_name=$1
    local host_dir=$EAP_HOME/../$DOMAIN_NAME/$host_name
    local type=${2:-$HOST_CONFIG}
    local config="host-${type}.xml"
    local bind_address=${3:-$BIND_ADDRESS}
    local bind_address_mngt=${4:-$bind_address}
    local slave_host

    case $type in
	"")
	    config="host.xml"
	    ;;
    esac

    case $type in
	master|controller)
	    bind_address=0.0.0.0
	    ;;
	*)
	    slave_host="-Djboss.domain.master.address=${CONTROLLER_HOST}"
	    ;;
    esac

    tmux new-window -n "$host_name" -t webinar \
        "\
        $EAP_HOME/bin/domain.sh \
	    --host-config=${config} \
	    -Djboss.domain.base.dir=${host_dir} \
	    -Djboss.bind.address=${bind_address} \
	    -Djboss.bind.address.unsecure=${bind_address} \
	    -Djboss.bind.address.management=${bind_address_mngt} \
	    -Djboss.host.name=${host_name} \
	    $slave_host \
	" \
	|| exit 1
}

CONF="controller:$CONTROLLER_HOST:master node1:127.1.0.11:slave node2:127.1.0.12:slave node3:127.1.0.13:slave"
#CONF="controller:$CONTROLLER_HOST:master"

tmux new -s webinar -d || true

for c in $CONF ; do
    h=$(echo $c |awk -F: '{ print $1; }')
    a=$(echo $c |awk -F: '{ print $2; }')
    t=$(echo $c |awk -F: '{ print $3; }')
    create_host $h
    start_host "$h" "${t}" "$a"
done
