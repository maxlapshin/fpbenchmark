#!/bin/bash

wget http://download.camlcity.org/download/findlib-1.3.3.tar.gz
tar zxf findlib-1.3.3.tar.gz
cd findlib-1.3.3
./configure
make
make install
cd ..

# wget http://erratique.ch/software/react/releases/react-0.9.2.tbz
# tar jxf react-0.9.2.tbz 
# cd react-0.9.2
# sh build
# sh build install
# cd ..



wget http://ocsigen.org/download/ocsigen-bundle-2.3.0.tar.gz
tar zxf ocsigen-bundle-2.3.0.tar.gz
cd ocsigen-bundle-2.3.0
./configure --with-react --with-ssl --with-pcre --with-netstring  --with-netsys  --with-cryptokit   --with-text  --with-calendar  --with-missing-libs
make install

