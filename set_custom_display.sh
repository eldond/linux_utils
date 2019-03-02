#!/bin/bash
# http://askubuntu.com/questions/700222/how-to-add-a-resolution-in-display-settings
# Adds a new resolution mode for monitor eDP-1 (the built in laptop display) and switches to it.
# My Dell lattitude E7470 laptop CAN display this mode, but it doesn't show up in my list of options by default (KDE plasma)
# This script adds it and switches to it.
# Used on Fedora 25-29 with Dell mentioned above.
# Lower resolution makes it easier to keep coding when the bus hits a pothole.
xrandr --newmode ""1280x720_60.00""   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync
xrandr --addmode eDP-1 1280x720_60.00
xrandr --output eDP-1 --mode 1280x720_60.00

