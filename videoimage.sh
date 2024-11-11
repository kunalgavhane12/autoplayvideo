#!/bin/bash

AD_DIR="/home/kunal/Ad/"
VIDEO_DIR="/home/kunal/video/"
IMAGE_DIR="/home/kunal/images/"

IMAGE_DURATION=3  # Duration for each image

# Function to close any previous mpv processes to avoid multiple instances
function close_previous_players() {
    pkill -f mpv
}

# Initialize image index
image_index=0

while true; do
    # Check if there are any videos in VIDEO_DIR
    if [ -z "$(ls -A $VIDEO_DIR 2>/dev/null)" ]; then
        # No main videos, fallback to ad videos or images only
        if [ -z "$(ls -A $AD_DIR 2>/dev/null)" ]; then
            echo "No ad videos found. Only displaying images..."
        else
            echo "No main videos found. Playing ad videos in place of main videos..."
            VIDEO_SOURCE=$AD_DIR
        fi
    else
        # Use main videos from VIDEO_DIR
        VIDEO_SOURCE=$VIDEO_DIR
    fi

    # Initialize array for videos
    videos=("$VIDEO_SOURCE"*)
    # Get list of images
    images=("$IMAGE_DIR"*)

    # Iterate over videos, displaying each in turn
    for video in "${videos[@]}"; do
        # Play the video
        echo "Playing video: $video"
        close_previous_players
        mpv --really-quiet "$video" &
        VIDEO_PID=$!
        wait $VIDEO_PID  # Wait for the video to finish

        # Display the current image
        image="${images[$image_index]}"
        if [[ "$image" =~ \.(jpg|jpeg|png|gif)$ ]]; then
            echo "Displaying image: $image"
            close_previous_players
            mpv --image-display-duration=$IMAGE_DURATION "$image" --no-audio &
            wait $!  # Wait for image to finish before moving on
        fi

        # Move to the next image, looping back to the start if at the end
        image_index=$(( (image_index + 1) % ${#images[@]} ))
    done
done
