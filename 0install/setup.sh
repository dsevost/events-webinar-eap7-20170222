#!/bin/bash

dir1=$(realpath $(dirname $0))
ANSWER_FILE=eap-7-install.xml

echo java -jar ~/download/jboss-eap-7.0.0-installer.jar ${dir1}/${ANSWER_FILE} -variablefile ${dir1}/${ANSWER_FILE}.variables
