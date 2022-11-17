import json
import requests
import os
import boto3
import date
import random

sqs_client = boto3.client('sqs')
api_key = "AIzaSyCywDFrDBrachFLhmO2rUgXGpk6XRCp0fE"
sqsurl = os.environ.get('sqs_url')
def lambda_handler(event, context):
    
    query = "ukraine"
    url = "https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=shorts%20" + query + "&type=video&videoDuration=short&key=" +api_key
    res = requests.get(url)

    json_resp = res.json()
    youtube_id_list = []
    dynamo_list = set()
    for item in json_resp["items"]:
        video_id = (item["id"]["videoId"])
        youtube_id_list.append(video_id)
        dynamo_list.add(video_id)
    dynamodb_client = boto3.client("dynamodb")
    dynamodb_client.put_item(TableName="Hashtag" Item={'Id':{'N':random.getrandbits(128)},'name':{'S':query}, 'videoIDs':{'SS':youtube_id_list}, 'searchDate':{'S':date.today()} }

    message = {
        'statusCode': 200,
        'body': youtube_id_list
    }
    sqs_client.send_message(sqsurl, message)
    return message


