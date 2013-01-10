#!/bin/bash

declare -i total
declare -a appsize

for f in `ls -d apps/*/{src,include}`; do
    a=`du -s $f `
    appsize=(`echo $a`)
    total=`expr $total + ${appsize[0]}`
done

echo "Erlang sources total ${total}K"
