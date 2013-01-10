#!/bin/bash

NODE=`hostname -a`

function setup_node {
   cp prod/$NODE/$1.config rels/$1/node/etc/app.config
   cp prod/$NODE/$1.vm.args rels/$1/node/etc/vm.args
   cp prod/$NODE/$1.snmp.agent.conf rels/$1/node/etc/snmp/agent/agent.conf
   cp prod/$NODE/$1.snmp.standard.conf rels/$1/node/etc/snmp/agent/standard.conf
   cp prod/$NODE/$1.snmp.usm.conf rels/$1/node/etc/snmp/agent/usm.conf
}

#setup_node app
#setup_node game
#setup_node web
setup_node public

