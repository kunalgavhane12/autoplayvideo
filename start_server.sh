#!/bin/bash
# Navigate to the directory containing the HTML file
cd /home/kunal/autoplayvideo

# Start the Python HTTP server and log output to a file
python3 -m http.server 8080 --bind 127.0.0.1

