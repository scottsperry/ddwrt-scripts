#!/bin/bash

datafiles="data/proc_net_dev_*"
interface=eth0
if [ $# -eq 1 ]; then
    interface=$1;
fi
output_out="bytesout.${interface}.csv"
output_in="bytesin.${interface}.csv"

echo 'date,value' >$output_out
echo 'date,value' >$output_in
for i in $datafiles 
 do 
 IFS='_' read -a array <<< "$i"
 thedate="${array[-1]}"
 echo -n "$thedate," >>$output_out
 echo -n "$thedate," >>$output_in
 
 awk "/^ *${interface}:/"' { if ($1 ~ /.*:[0-9][0-9]*/) { sub(/^.*:/, "") ; print $1 } else { print $2 } }' $i >> $output_in
 awk "/^ *${interface}:/"' { if ($1 ~ /.*:[0-9][0-9]* /) { print $9 } else { print $10 } }' $i >> $output_out


done

