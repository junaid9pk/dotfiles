#!/bin/bash

active=$(hyprctl activewindow -j)

workspace_name=$(echo "$active" | jq -r '.workspace.name // empty')
floating=$(echo "$active" | jq -r '.floating // empty')
pseudo=$(echo "$active" | jq -r '.pseudo // empty')

if [[ "$workspace_name" == "special:magic" ]]; then
    echo "󱡄"
elif [[ "$floating" == "true" ]]; then
    echo "󰊠"
else
    echo ""
fi
