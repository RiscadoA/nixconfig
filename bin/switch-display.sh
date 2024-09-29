#!/usr/bin/env bash

if xrandr --query | grep 'HDMI-A-0 connected'; then
    xrandr --output eDP --off --output HDMI-A-0 --auto
else
    xrandr --output HDMI-A-0 --off --output eDP --auto
fi
