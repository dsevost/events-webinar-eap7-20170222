#!/bin/bash

dir1=$(realpath -Pe $(dirname $0))

set -x

~/app/eap-7/bin/jboss-cli.sh --file=${dir1}/apply_patch.cli
