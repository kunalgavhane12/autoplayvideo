#!/bin/bash

AD_DIR="/home/kunal/Ad"
VIDEO_DIR="/home/kunal/Videos"
IMAGE_DIR="/home/kunal/images"

IMAGE_DURATION=5  # Duration for each image in seconds

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

while true; do
    # Check if the video file exists before proceeding
    if [[ -f "${videos[$video_index]}" ]]; then
        video="${videos[$video_index]}"
        echo "Playing video: $video"

        # Start playing the video
        mpv --really-quiet "$video" &
        video_pid=$!

        # Track the time elapsed during the video playback
        play_duration=0
        while kill -0 $video_pid 2>/dev/null; do
            sleep 1
            ((play_duration++))

            # After every 10 seconds of playback, pause for 5 seconds
            if ((play_duration % 10 == 0)); then
                pkill -SIGSTOP mpv
                echo "Paused video for 5 seconds"

		# Display two images, each for 2 seconds
                for i in {0..1}; do
                    if [[ -f "${images[$image_index]}" ]]; then
                        image="${images[$image_index]}"
                        echo "Displaying image: $image"
                        feh "$image" &
                        sleep $IMAGE_DURATION
                        pkill -f feh  # Close the image after the duration

                        # Move to the next image, looping back if at the end
                        image_index=$(( (image_index + 1) % ${#images[@]} ))
                    else
                        echo "No images available."
                    fi
                done
                pkill -SIGCONT mpv
                echo "Resumed video"
            fi
        done

        # Wait for the video to finish
        wait $video_pid

        # Move to the next video, looping back if at the end
        video_index=$(( (video_index + 1) % ${#videos[@]} ))
    else
        echo "No videos available."
        break  # Exit loop if no videos are found
    fi
done
