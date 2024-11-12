#!/bin/bash

AD_DIR="/home/kunal/Ad/"
VIDEO_DIR="/home/kunal/Videos"
IMAGE_DIR="/home/kunal/images/"

IMAGE_DURATION=3  # Duration for each image in seconds

# Function to close any previous mpv processes to avoid multiple instances
function close_previous_players() {
    pkill -f mpv
}

# Initialize indexes for videos and images
video_index=0
image_index=0

# Get list of available video and image files
videos=("$VIDEO_DIR"/*.*)  # Match all files with an extension in VIDEO_DIR
images=()

# Ensure that only valid image extensions are included
for img in "$IMAGE_DIR"/*; do
    if [[ "$img" =~ \.(jpg|jpeg|png|gif)$ ]]; then
        images+=("$img")
    fi
done

# Check if there are any videos in VIDEO_DIR; if not, use AD_DIR instead
if [ -z "$(ls -A $VIDEO_DIR 2>/dev/null)" ] && [ -n "$(ls -A $AD_DIR 2>/dev/null)" ]; then
    videos=("$AD_DIR"/*.*)
fi

# Main loop to alternate between video and image
while true; do
    # Play one video and increment video index
    if [[ -f "${videos[$video_index]}" ]]; then
        video="${videos[$video_index]}"
        echo "Playing video: $video"
#        close_previous_players
        mpv --really-quiet "$video" &
        wait $!  # Wait for the video to finish

        # Move to the next video, looping back if at the end
        video_index=$(( (video_index + 1) % ${#videos[@]} ))
    else
        echo "No videos available."
    fi

    # Display one image and increment image index
    if [[ -f "${images[$image_index]}" ]]; then
        image="${images[$image_index]}"
        echo "Displaying image: $image"
        mpv --image-display-duration=$IMAGE_DURATION "$image" --no-audio &
        wait $!  # Wait for the image display to complete

        # Move to the next image, looping back if at the end
        image_index=$(( (image_index + 1) % ${#images[@]} ))
    else
        echo "No images available."
    fi
done
