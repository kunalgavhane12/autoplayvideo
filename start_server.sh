#!/bin/bash
# Navigate to the directory containing the HTML file
cd /home/dt-rpi-iml-9002/autoplayvideo

# Start the Python HTTP server and log output to a file
python3 -m http.server 8080 --bind 192.168.29.109

