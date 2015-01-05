#!/bin/bash

allfiles=0
datafiles="data/proc_net_dev_*"
interface=eth0

show_help() {
    echo 'psn2csv <interface>';
    echo "  <interface> defaults to eth0 if not specified"
    echo "  -a all files, not just those in the past 24 hours"
}

while getopts "h?a" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    a)  allfiles=1
        ;;
    esac
done
shift $((OPTIND-1))

[ "$1" = "--" ] && shift

if [ $# -eq 1 ]; then
    interface=$1;
fi
output_out="bytesout.${interface}.csv"
output_in="bytesin.${interface}.csv"

echo 'date,value' >$output_out
echo 'date,value' >$output_in

dayago=`date +%Y%m%d%H%M%S -d 'yesterday'`

for i in $datafiles 
 do 
 IFS='_' read -a array <<< "$i"
 thedate="${array[-1]}"

 # skip files older than 24 hours unless all files specified
 if [ $allfiles == 0 ] && [ $thedate -lt $dayago ];
 then
   continue;
 fi

 echo -n "$thedate," >>$output_out
 echo -n "$thedate," >>$output_in
 
 awk "/^ *${interface}:/"' { if ($1 ~ /.*:[0-9][0-9]*/) { sub(/^.*:/, "") ; print $1 } else { print $2 } }' $i >> $output_in
 awk "/^ *${interface}:/"' { if ($1 ~ /.*:[0-9][0-9]* /) { print $9 } else { print $10 } }' $i >> $output_out


done

