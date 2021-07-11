#!/bin/bash

# set vars
config_file="/etc/log-sender.conf"
pid_file="/var/run/log-sender.pid"

function get_config_from_file {
    log_receiver_port=`grep log_receiver_port $config_file | cut --delimiter '=' --fields 2`
    log_receiver_fqdn=`grep log_receiver_fqdn $config_file | cut --delimiter '=' --fields 2`
    logfiles=`cat $config_file | awk -F"=" '/logfiles=/  { print $2 }' #| sed -r 's#^#\"#g;s#,#\" \"#g;s#$#\"#g'`
    # awk: nimm alles hinter name= als eine variable
    # sed: ersetze "," zeileanfang und zeilen ende mit "
}

function output_help {
    echo "[start|stop|restart|help]"
    echo "Send logs to a remote server - purely written in bash and gnu-tools"
}

function restart_logging {
    if test -f "$pid_file"; then
        stop_logging # funktionen
    fi
    start_logging # funktionen
}

function stop_logging {
    # checkif process is running
    if test -f "$pid_file"; then
        # kill any pid in that file
        kill `cat "$pid_file"`
        # remove pid
        rm "$pid_file"
    else
        echo "script is not running"
    fi
}

function start_logging {
    if test -f "$pid_file"; then
        echo "script is already running"
    else
        # debug
        #echo "in start"
        #echo ${logfile_paths[1]}
        # for every path in ... do
        for i in "${logfile_paths[@]}"
        do
            #debug
            echo $i
            # start process in background
        	  tail --lines=0 --follow "$i" | nc -N $log_receiver_fqdn $log_receiver_port &
            # save processid of background process
            echo $! >> "$pid_file"
        done
    fi
}





# "main"
# lese/binde ein config ein
if test -f "$config_file"; then
    get_config_from_file
    # debug
     echo $logfiles
    # echo "lese config"
else
    echo "No config at" "$config_file"
    exit 1
fi

# erstelle array für logfile pfade, vorher müssen vars natürlich gesetzt sein
# leerzeichen erlaubt, werte kmma getrennt
IFS=',' read -r -a logfile_paths <<< $logfiles

case "$1" in
    start)
        start_logging
        ;;
    stop)
        stop_logging
        ;;
    restart)
        restart_logging
        ;;
    help)
        output_help
        ;;
    *)
        start_logging
esac
