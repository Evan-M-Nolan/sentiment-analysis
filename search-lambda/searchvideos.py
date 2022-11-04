import json
import requests
import os

api_key = "AIzaSyCywDFrDBrachFLhmO2rUgXGpk6XRCp0fE"
def lambda_handler(event, context):
    query = "ukraine"
    url = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=shorts%20" + query + "&type=video&videoDuration=short&key=" +api_key
    res = requests.get(url)

    json_resp = res.json()
    youtube_id_list = []
    for item in json_resp["items"]:
        video_id = (item["id"]["videoId"])
        youtube_id_list.append(video_id)
    return {
        'statusCode': 200,
        'body': youtube_id_list
    }
