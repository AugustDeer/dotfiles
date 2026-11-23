#!/bin/sh
STEP=50
MIN=80
MAX=600

mon=$(hyprctl monitors)
name=$(printf '%s\n' "$mon" | awk '/^Monitor/{print $2}' | head -1)
preset=$(printf '%s\n' "$mon" | awk -F': ' '/colorManagementPreset/{print $2}' | head -1)

if [ "$preset" != "hdr" ]; then
  exec noctalia msg "brightness-$1"
fi

cur=$(printf '%s\n' "$mon" | awk -F': ' '/sdrMaxLuminance/{print $2}' | head -1)
scale=$(printf '%s\n' "$mon" | awk -F': ' '{ sub(/^[ \t]+/, "") } $1 == "scale" { print $2 }' | head -1)
case "$1" in
  up)
    new=$((cur + STEP))
    [ "$new" -gt "$MAX" ] && new=$MAX
    ;;
  down)
    new=$((cur - STEP))
    [ "$new" -lt "$MIN" ] && new=$MIN
    ;;
  *)
    exit 1
    ;;
esac

mode=$(printf '%s\n' "$mon" | awk '/ at /{print $1}' | head -1 | sed 's/\.[0-9]*$//')
pos=$(printf '%s\n' "$mon" | awk '/ at /{print $3}' | head -1)
vrr=0
printf '%s\n' "$mon" | grep -q 'vrr: true' && vrr=1

hyprctl eval "hl.monitor({output=\"$name\", mode=\"$mode\", position=\"$pos\", scale=$scale, bitdepth=10, vrr=$vrr, cm=\"hdr\", max_luminance=600, sdr_max_luminance=$new})"
