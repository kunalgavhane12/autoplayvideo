# Video Download and Playback System

This project consists of a set of scripts that download video files from URLs received via MQTT messages, served via HTTP, and played based on availability. It uses the Paho MQTT client for communication and the `requests` library for handling http requests.

## Features

- Subscribe to an MQTT topic to receive video URL.
- Downloads videos and saves with unique filenames.
Provides an HTTP interface to access the files.
Opens an HTML page in the default web browser.
Plays video or ad video depending on availability.

## Requirements

- Python 3.x
paho-mqtt
requests
mpv

You can install all required libraries by pip:
 
pip install paho-mqtt requests
 
 Configuration
You will most likely need to override the following constants in the scripts
 
MQTT_BROKER The address of the MQTT broker. Defaults to broker.emqx.io.
MQTT_PORT : MQTT port on which the connection will be made. Default is 1883. MQTT_TOPIC : MQTT topic the script is subscribed to. The default is video/link. DOWNLOAD_PATH : where the video downloaded from the feed will be saved. The download path defaults to /home/kunal/Video. How to Use
Video Download Script Running Ensure the MQTT broker is running and accessible.

To run the script, just use: 
bash Copy
mosquitto_pub -h broker.emqx.io -t video/link -m "http://example.com/video.mp4" The script downloads the video and saves it in the directory provided with a unique filename. Running with Shell Script You can execute the Python script in your virtual environment with this shell script.

Assuming your virtual environment is set up at /home/kunal/autoplayvideo/venv.

Run the shell script:

bash Copy Paste
./run_video_download.sh
To share files over HTTP, use the attached shell script:
 
cd to your directory with your HTML files
 
bash
Copy code
./server.sh
You should now have a Python HTTP server running on port 8000 and be able to reach your files in the directory.
 
Viewing the HTML Page 
 To open the HTML page in your default web browser, use the attached shell script:
 
bash
Copy code
./open_page.sh
This will open index.html located in autoplayvideo
 Video Plays
To play video or advertisement in continuous cycles based on availability, use the following shell script below:

Run the script:

bash
Copy code
./playvideo.sh
This script looks for video in the VIDEOS directory. In case it is available, then it plays; else plays advertisement videos in the AD_DIR.

Unique Filename
If it finds video of the same name, the script appends the number to make it unique, like 1.mp4, 2.mp4, etc.

Error Handling
The script catches any errors that occur in the HTTP request process and prints a message with an informational code for failure.
