#!/bin/bash
# erstelle array für logfile pfade
declare -a logfile_paths

# lese/binde ein
source /home/mg/log-sender.conf


case "$1" in
  start)
    # for every path in ... do
    for i in "${logfile_paths[@]}"
    do
      # log start to syslog
      logger  "log-sender for started"
      # start process in background
    	tail --lines=0 -f $i | nc -N localhost 12345 &
      # save processid of background process
      echo $! >> /var/run/log-sender.pid
      echo $'\n'
    done
    ;;
  stop)
    if test -f /var/run/log-sender.pid; then
      kill `cat /var/run/log-sender.pid`
      rm /var/run/log-sender.pid
      logger  "log-sender for stopped"
    else
      echo "script is not running"
    fi
    ;;
  restart)
    if test -f /var/run/log-sender.pid; then
      $0 stop
    fi    
    $0 start
    logger  "log-sender for restarted"
    ;;
  help)
    echo "start|stop|restart|help"
    echo "Send logs to a remote server - purely wirtten in bash and gnu-tools"
    ;;
  *)
    $0 start
esac
