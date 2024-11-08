import paho.mqtt.client as mqtt
import requests
import os

MQTT_BROKER = "broker.emqx.io"
MQTT_PORT = 1883
MQTT_TOPIC = "video/link"
DOWNLOAD_PATH = "/home/dt-rpi-iml-9001/video"

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
    client.subscribe(MQTT_TOPIC)

def on_message(client, userdata, message):
    video_url = message.payload.decode('utf-8')
    print(f"Received video URL: {video_url}")
    download_video(video_url)

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect(MQTT_BROKER, MQTT_PORT, 60)

client.loop_forever()

