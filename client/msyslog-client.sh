#!/bin/bash

# setze Variablen
config_file="/etc/msyslog-client.conf"
pid_file="/run/msys/msyslog-client.pid"

# setze Variable FQDN
function set_fqdn {
    domain=$(resolvectl status | awk '/DNS Domain/ { print $3}')
    fqdn=$(hostname).$domain
}
# kombiniere FQDN mit Logfilename
function set_prefix {
    sed "s/^/$i/;s/^/$fqdn\: /" "$1"
}
# Lese Config aus Datei aus und speichere in Variablen
function get_config_from_file {
    # lese/binde ein config ein
    if test -f "$config_file"; then
        # https://dzone.com/articles/bash-snippet-reading-values-from-a-configuration-f
        log_receiver_port=$(awk -F"=" '/log_receiver_port=/ { print $2 }' $config_file)
        log_receiver_fqdn=$(awk -F"=" '/log_receiver_fqdn=/ { print $2 }' $config_file)
        # erstelle array "logfile_paths"
        # shellcheck disable=2046
        IFS=',' read -r -a logfile_paths <<< $( awk -F"=" '/logfiles=/ { print $2 }' $config_file)
        # erstelle array für logfile pfade, vorher müssen vars natürlich gesetzt sein
        # leerzeichen erlaubt, werte kmma getrennt
        # awk: nimm alles hinter name= als eine variable
    else
        echo "Error1: No config at" "$config_file"
        exit 1
    fi
}
function output_help {
    figlet mSYSLOG
    cat <<EOF
Usage:
  - msyslog-client.sh [OPTIONS]
  - systemctl start|stop|restart|status msyslog-client.service

Options:
    -h, --help                  Displays this text.
    -s, --status                Displays the current status of the script.


EOF
}

function check_logfile_paths {
    # check if all logfiles from the config exist
    for i in "${logfile_paths[@]}"
    do
        if test ! -f "$i"; then # wenn datei NCIHT existiert
            echo "Error2:" "$i" "does not exist! Check" $config_file
            exit 2
        fi
    done
}
function output_status {
    # checkif process is running
    if test -f "$pid_file"; then
        echo "config-file:" $config_file
        echo "pid-file:" $pid_file
        echo "running processes:"
        cat  "$pid_file"
    else
        echo "script is not running"
    fi
}

function stop_logging {
    # checkif process is running
    if test -f "$pid_file"; then
        # kill any pid in that file
        kill "$(cat $pid_file)" &>/dev/null
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
        check_logfile_paths # funktion
        set_fqdn
        # for every path in ... do
        for i in "${logfile_paths[@]}"
        do
            # start processes in background
            # starte jeden prozess in einer subshell und schreibe die pid in eine datei
            # shellcheck disable=2016
        	  (tail --lines=0 --follow "$i" & echo $! >> "$pid_file") | (stdbuf -oL -eL awk -v prefix="$fqdn $i" '{print prefix $0}' & echo $! >> "$pid_file") | nc "$log_receiver_fqdn" "$log_receiver_port" & echo $! >> "$pid_file" &
            #https://unix.stackexchange.com/questions/25372/turn-off-buffering-in-pipe
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
    --help | -h | help)
        output_help
        ;;
    --status | -s | status)
        output_status
        ;;
    *)
        output_status
esac

exit 0
