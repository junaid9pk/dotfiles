#!/bin/bash

# Get available sinks
sinks=$(pactl list sinks short | awk '{print $1,$2}')
current=$(pactl info | grep "Default Sink" | cut -d' ' -f3)

# Create rofi menu
selected=$(echo "$sinks" | awk -v current="$current" '
    $2 == current {print $1 "  " $2; next}
    {print $1 "     " $2}
' | rofi -dmenu -p "Select audio output" | awk '{print $NF}')

# Set new default sink
[ -n "$selected" ] && pactl set-default-sink "$selected"

# Move all audio streams to new sink
pactl list short sink-inputs | while read stream; do
    stream_id=$(echo "$stream" | awk '{print $1}')
    pactl move-sink-input "$stream_id" "$selected"
done
