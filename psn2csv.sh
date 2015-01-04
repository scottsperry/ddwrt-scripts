#!/bin/bash

datafiles="data/proc_net_dev_*"
interface=eth0
if [ $# -eq 1 ]; then
    interface=$1;
fi
output="bytesout.${interface}.csv"


echo 'date,value' >$output
for i in $datafiles 
 do 
 IFS='_' read -a array <<< "$i"
 thedate="${array[-1]}"
 echo -n "$thedate," >>$output
# ./parse_psn1.sh $i $interface >>$output

 awk "/^ *${interface}:/"' { if ($1 ~ /.*:[0-9][0-9]*/) { sub(/^.*:/, "") ; print $1 } else { print $2 } }' $i >> $output
done

