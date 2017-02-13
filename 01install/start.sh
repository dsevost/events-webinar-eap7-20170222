#!/bin/bash

set -x

~/app/eap-7/bin/standalone.sh -b 0.0.0.0 -bmanagement=0.0.0.0
