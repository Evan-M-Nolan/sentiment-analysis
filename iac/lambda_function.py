import json
import os
import datetime
import boto3
from boto3.dynamodb.conditions import Key, Attr

client = boto3.resource('dynamodb')
hashtag_table = os.environ.get('dynamodb_hashtag')

def lambda_handler(event, context):
    
    search_string = event["queryStringParameters"]['search']
    default = True
    date = datetime.datetime.now() - datetime.timedelta(days=3)
    date = date.strftime('%s')
    print(date)
    table = client.Table(hashtag_table)
    
    if (search_string is not None and len(search_string) > 0):
        default = False
        
    if default:
        #do the default scan
        data = table.scan(
            TableName=hashtag_table,
            FilterExpression=Attr('searchDate').gt(date)
        )
        
    else:
        #search for the specific hashtag
        data = table.query(
            KeyConditionExpression=Key('Id').eq(search_string)
        )
    
    results = data['Items']
    
    response = {
        'statusCode': 200,
        'body': json.dumps(results),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        }
        
    }
    return response