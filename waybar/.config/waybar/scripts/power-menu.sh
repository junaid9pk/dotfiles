#!/usr/bin/env bash
set -euo pipefail

choice=$(printf "lock\nsuspend\nreboot\npoweroff\n" | wofi --dmenu -p "Power")

case "$choice" in
  lock)
    hyprlock
    ;;
  suspend)
    systemctl suspend
    ;;
  reboot)
    systemctl reboot
    ;;
  poweroff)
    systemctl poweroff
    ;;
  *)
    exit 0
    ;;
esac
