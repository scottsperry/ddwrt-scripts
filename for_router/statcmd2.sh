#!/bin/sh
# this runs periodically (from cron) to collect stats
cat /proc/net/dev >proc_net_dev_`date +%Y%m%d%H%M%S`
