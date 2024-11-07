#!/bin/bash
# Navigate to the directory containing the HTML file
cd /home/kunal/autoplayvideo

# Start the Python HTTP server
python3 -m http.server 8080 --bind 192.168.29.222

