import boto3
from pytube import YouTube
import os 

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    bucket = os.environ.get('raw-data-bucket')
    videos = []
    for record in event["body"]:
        videos.append(record)
    
    for videoId in videos:
        url = YouTube('https://www.youtube.com/watch?v='+videoId)
        video = url.streams.get_highest_resolution()
        key = "ukraine/"
        path_to_download_folder = "/tmp/"
        file = video.download(path_to_download_folder, filename=videoId+".mp4")
        key+=videoId+".mp4"
        s3_client.upload_file(file, bucket, key)