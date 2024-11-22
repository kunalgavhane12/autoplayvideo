#!/bin/bash

# Get the current username dynamically
USER_HOME="/home/$USER"

# Navigate to the project directory
cd "$USER_HOME/autoplayvideo" || { echo "Directory not found"; exit 1; }

# Check if already in the virtual environment (inside 'myenv')
if [ -z "$VIRTUAL_ENV" ]; then
  # If not, activate the virtual environment
  if [ -d "$USER_HOME/myenv" ]; then
    source "$USER_HOME/myenv/bin/activate"
  else
    echo "Virtual environment not found"
    exit 1
  fi
else
  echo "Already inside the virtual environment: $VIRTUAL_ENV"
fi

# Ensure required Python packages are installed
echo "Checking for required Python packages..."

# Check if 'paho-mqtt' is installed, if not install it
if ! python -c "import paho.mqtt.client" &>/dev/null; then
  echo "'paho-mqtt' not found. Installing it now..."
  pip install paho-mqtt
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

