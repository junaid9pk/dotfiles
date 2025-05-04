#!/bin/bash

if bluetoothctl show | grep -q "Powered: yes"; then
    bluetoothctl power off
    notify-send "Bluetooth" "Turned off"
else
    bluetoothctl power on
    notify-send "Bluetooth" "Turned on"
    # Auto-connect to trusted devices
    sleep 2
    for device in $(bluetoothctl paired-devices | awk '{print $2}'); do
        if bluetoothctl info "$device" | grep -q "Trusted: yes"; then
            bluetoothctl connect "$device"
        fi
    done
fi
