# import paho.mqtt.client as mqtt
# import requests
# import os
# import re

# MQTT_BROKER = "broker.emqx.io"
# MQTT_PORT = 1883
# MQTT_TOPIC = "video/link"
# DOWNLOAD_PATH = "/home/kunal/video"

# os.makedirs(DOWNLOAD_PATH, exist_ok=True)

# def get_unique_filename(base_name):
#     base, ext = os.path.splitext(base_name)
#     counter = 1
#     new_filename = os.path.join(DOWNLOAD_PATH, f"{counter}{ext}")

#     while os.path.exists(new_filename):
#         counter += 1
#         new_filename = os.path.join(DOWNLOAD_PATH, f"{counter}{ext}")

#     return new_filename

# def is_google_drive_url(url):
#     # Check if the URL is from Google Drive
#     return 'drive.google.com' in url

# def get_google_drive_download_url(google_drive_url):
#     # Use a more flexible regular expression to extract the file ID from the URL
#     file_id = None
#     match = re.search(r'drive\.google\.com/.*?\/d\/([a-zA-Z0-9_-]+)', google_drive_url)
#     if match:
#         file_id = match.group(1)

#     if file_id:
#         # Construct the direct download link for Google Drive
#         return f"https://drive.google.com/uc?id={file_id}&export=download"
#     else:
#         raise ValueError("Invalid Google Drive URL")

# def download_video(video_url):
#     try:
#         if is_google_drive_url(video_url):
#             # Get the direct download link for Google Drive URLs
#             video_url = get_google_drive_download_url(video_url)

#         # Perform the actual download
#         response = requests.get(video_url, stream=True)
#         response.raise_for_status()  # Raise an exception for HTTP errors

#         # Extract the file extension from the URL or use a default one
#         _, ext = os.path.splitext(video_url)
#         if not ext:  # If no extension is detected, assume it might be a video file
#             ext = ".mp4"  # Default to MP4 if no extension found

#         unique_filename = get_unique_filename(ext)

#         # Write the video file to disk
#         with open(unique_filename, 'wb') as video_file:
#             for chunk in response.iter_content(chunk_size=8192):
#                 video_file.write(chunk)

#         print(f"Downloaded: {unique_filename}")
#     except requests.exceptions.RequestException as e:
#         print(f"Error downloading video: {e}")
#     except ValueError as e:
#         print(f"Error with Google Drive URL: {e}")

# def on_connect(client, userdata, flags, rc):
#     print(f"Connected to broker with result code {rc}")
#     client.subscribe(MQTT_TOPIC)

# def on_message(client, userdata, message):
#     video_url = message.payload.decode('utf-8')
#     print(f"Received video URL: {video_url}")
#     download_video(video_url)

# client = mqtt.Client()
# client.on_connect = on_connect
# client.on_message = on_message

# client.connect(MQTT_BROKER, MQTT_PORT, 60)

# client.loop_forever()



import paho.mqtt.client as mqtt
import requests
import os

MQTT_BROKER = "broker.emqx.io"
MQTT_PORT = 1883
MQTT_TOPIC = "video/link"
DOWNLOAD_PATH = "/home/kunal/video"

os.makedirs(DOWNLOAD_PATH, exist_ok=True)

def get_unique_filename(base_name):
    base, ext = os.path.splitext(base_name)
    counter = 1
    new_filename = os.path.join(DOWNLOAD_PATH, f"{counter}{ext}")
    
    while os.path.exists(new_filename):
        counter += 1
        new_filename = os.path.join(DOWNLOAD_PATH, f"{counter}{ext}")
    
    return new_filename

def download_video(video_url):
    try:
        _, ext = os.path.splitext(video_url)
        unique_filename = get_unique_filename(ext)
        
        print(f"Starting download: {video_url}")
        
        response = requests.get(video_url, stream=True)
        response.raise_for_status()
        
        with open(unique_filename, 'wb') as video_file:
            for chunk in response.iter_content(chunk_size=8192):
                video_file.write(chunk)

        print(f"Downloaded: {unique_filename}")
    except requests.exceptions.RequestException as e:
        print(f"Error downloading video: {e}")

def on_connect(client, userdata, flags, rc):
    print(f"Connected to broker with result code {rc}")
    if rc == 0:
        print("Successfully connected to the MQTT broker.")
    client.subscribe(MQTT_TOPIC)

def on_message(client, userdata, message):
    video_url = message.payload.decode('utf-8')
    print(f"Received message on topic {message.topic}: {video_url}")
    download_video(video_url)


client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)

client.loop_forever()

