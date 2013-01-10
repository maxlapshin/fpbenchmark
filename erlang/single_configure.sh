#!/bin/bash

LOCAL_IP=${1:-"`hostname -i`"}

cd rels/public/node/etc
./configure -ip $LOCAL_IP -sync false -pool 4000000
