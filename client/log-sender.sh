#!/bin/bash

function get_help {
    echo "[start|stop|restart|help]"
    echo "Send logs to a remote server - purely written in bash and gnu-tools"
}

function restart {
    if test -f "/var/run/log-sender.pid"; then
        $0 stop
    fi
    $0 start
    logger "log-sender restarted"
}

function stop {
    # checkif process is running
    if test -f "/var/run/log-sender.pid"; then
        # kill any pid in that file
        kill `cat "/var/run/log-sender.pid"`
        # remove pid
        rm "/var/run/log-sender.pid"
        logger "log-sender stopped"
    else
        echo "script is not running"
    fi
}

function start {
    if test -f "/var/run/log-sender.pid"; then
        echo "script is already running"
    else
        # for every path in ... do
        for i in "${logfile_paths[@]}"
        do
            # start process in background
        	  tail --lines=0 -f $i | nc -N localhost 12345 &  #HIER NOCH VARS
            # save processid of background process
            echo $! >> "/var/run/log-sender.pid"
            logger "log-sender started"
        done
    fi
}

# erstelle array für logfile pfade
declare -a logfile_paths

# lese/binde ein config ein
if test -f "/etc/log-sender.conf"; then
  source "/etc/log-sender.conf"
else
  echo "No config at /etc/log-sender.conf"
  exit 1
fi

# "main"
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    help)
        get_help
        ;;
    *)
        start
esac
