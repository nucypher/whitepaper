#!/bin/bash

# This script compiles the document as soon as all the .tex files in the project are updated.
# In debian-based distros, it needs inotify-tools and (optionally) libnotify-bin

inotifywait -mr -e create ./ | while read dir event file; do
    if [[ $file =~ .*\.tex ]]
    then
        make && notify-send "Latex document compiled" || notify-send "Latex error"
    fi
done
