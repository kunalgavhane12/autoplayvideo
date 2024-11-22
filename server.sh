#!/bin/bash

# Get the current username dynamically
USER_HOME="/home/$USER"

# Navigate to the project directory
cd "$USER_HOME/autoplayvideo" || { echo "Directory not found"; exit 1; }

# Activate the virtual environment if it exists
if [ -d "$USER_HOME/autoplayvideo/venv" ]; then
  source "$USER_HOME/autoplayvideo/venv/bin/activate"
else
  echo "Virtual environment not found"
  exit 1
fi

# Start the Python HTTP server in the background and log output
nohup python3 -m http.server 8080 --bind 0.0.0.0 > server.log 2>&1 &

# Check if the server started successfully
if [ $? -eq 0 ]; then
  echo "HTTP server started successfully on port 8080."
else
  echo "Failed to start the HTTP server."
  exit 1
fi

# Run the video download script
python "$USER_HOME/autoplayvideo/video_download.py" || { echo "Video download script failed"; exit 1; }

# Optionally, ensure the server is stopped after the download finishes
# kill $!

