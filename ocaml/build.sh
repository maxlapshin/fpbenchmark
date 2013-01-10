#!/bin/bash

wget http://ocsigen.org/download/ocsigen-bundle-2.3.0.tar.gz
tar zxf ocsigen-bundle-2.3.0.tar.gz
cd ocsigen-bundle-2.3.0
./configure --prefix=`pwd`/../ocsigen
make install

