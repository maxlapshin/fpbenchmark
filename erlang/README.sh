#!/bin/bash

./rebar get-deps
./rebar compile
./release.sh
./release_sync.sh
./single_configure.sh
./start.sh


