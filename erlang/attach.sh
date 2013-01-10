#!/bin/sh

NODE=${1:-"public"}
BIN="rels/$NODE/node/bin/ns_node"

$BIN attach

