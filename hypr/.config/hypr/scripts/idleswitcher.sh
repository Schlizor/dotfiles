#!/bin/bash

pid=$(pgrep -f hypridle)

if [ -n "$pid" ]; then
    # Hypridle is running, kill it
    kill $pid
    notify-send "Hypridle Killed"
else
    # Hypridle is not running, start it
    hyprctl dispatch exec hypridle
    notify-send "Hypridle Started"
fi

#if pgrep -x "hypridle" > /dev/null
#then
#
#   send_notification "Hypridle stopped"
#else 

#    send_notification "Hypridle is not running"
#fi