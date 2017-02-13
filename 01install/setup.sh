#!/bin/bash

dir1=$(realpath -Pe $(dirname $0))
ANSWER_FILE=eap-7-install.xml

set -x

java -jar ~/download/jboss-eap-7.0.0-installer.jar ${dir1}/${ANSWER_FILE} -variablefile ${dir1}/${ANSWER_FILE}.variables

grep -q EAP_HOME= ~/.bash_profile || {
    echo -e "EAP_HOME=~/app/eap-7\nexport EAP_HOME" >> ~/.bash_profile
}
