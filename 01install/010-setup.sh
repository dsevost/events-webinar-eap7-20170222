#!/bin/bash

dir1=$(realpath $(dirname $0))
ANSWER_FILE=eap-7-install.xml

for a in {0..4} ; do ip a add 127.1.0.1$a/24 dev lo ; done

set -x

java -jar ~/downloads/jboss/jboss-eap-7.0.0-installer.jar ${dir1}/${ANSWER_FILE} -variablefile ${dir1}/${ANSWER_FILE}.variables

grep -q EAP_HOME= ~/.bash_profile || {
    echo -e "EAP_HOME=~/app/eap-7\nexport EAP_HOME" >> ~/.bash_profile
}
