#!/bin/bash

# set vars
config_file="/etc/msyslog.conf"
pid_file="/var/run/msyslog.pid"

function get_config_from_file {
    # lese/binde ein config ein
    if test -f "$config_file"; then
        log_receiver_port=$(cat $config_file | awk -F"=" '/log_receiver_port=/  { print $2 }')
        log_receiver_fqdn=$(cat $config_file | awk -F"=" '/log_receiver_fqdn=/  { print $2 }')
        # erstelle array "logfile_paths"
        IFS=',' read -r -a logfile_paths <<< $(cat $config_file | awk -F"=" '/logfiles=/  { print $2 }')
        # erstelle array für logfile pfade, vorher müssen vars natürlich gesetzt sein
        # leerzeichen erlaubt, werte kmma getrennt
        # awk: nimm alles hinter name= als eine variable
    else
        echo "No config at" "$config_file"
        exit 1
    fi
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
        kill $(cat "$pid_file")
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
        # for every path in ... do
        for i in "${logfile_paths[@]}"
        do
            # start processes in background
        	  tail --lines=0 --follow "$i" | nc -N $log_receiver_fqdn $log_receiver_port &
            # save processid of background process
            echo $! >> "$pid_file"
        done
    fi
}

# "main"
get_config_from_file

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
