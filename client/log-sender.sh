#!/bin/bash
# erstelle array für logfile pfade
declare -a logfile_paths
declare -a bg_pids
# lese/binde ein
source /home/mg/log-sender.conf



# for every path in ... do
for i in "${logfile_paths[@]}"
do
  # log start to syslog
  logger  "log-sender for " $i "started"
  # start process in background
	tail --lines=0 -f $i | nc -N localhost 12345 &
  # save processid of background process
  bg_pids[$i]=$!
  # wait for all background commands exit
  wait
done
