#!/bin/bash

AD_DIR="/home/kunal/Videos/*"
VIDEO_DIR="/home/kunal/video/*"

while true; do
    if [ -z "$(ls -A $VIDEO_DIR 2>/dev/null)" ]; then
        # If VIDEO_DIR is empty, play ad videos
        mpv $AD_DIR
    else
        # If VIDEO_DIR has videos, play them
        mpv $VIDEO_DIR
    fi
done

