import json
import boto3 as boto3
import logging
import cv2

# boto3 S3 initialization
s3_client = boto3.client("s3")
s3 = boto3.resource('s3')


def getFrame(sec, vidcap, count, destination_bucket_folder, videoId):
    # Reads in the image from the time of video
    vidcap.set(cv2.CAP_PROP_POS_MSEC, sec * 1000)
    hasFrames, image = vidcap.read()

    # If it has a frame dump .png file into destination bucket
    if hasFrames:
        file_to_send = "/tmp/image_" + str(count) + ".png"
        cv2.imwrite(file_to_send, image)  # save frame as PNG file
        s3_client.upload_file(file_to_send, destination_bucket_folder, videoId + "image_" + str(count) + ".png")

    return hasFrames


def lambda_handler(event, context):
    # Bucket to store images
    destination_bucket_name = 'processed-data-bucket-514-team6'

    # Bucket Name where video file gets pulled from
    source_bucket_name = event['Records'][0]['s3']['bucket']['name']

    # Filename of object used to get videoID which will be the folder name that all the images get stored in
    file_key_name = event['Records'][0]['s3']['object']['key']
    sliceStrSlash = file_key_name.strip().find("/")
    sliceStrDot = file_key_name.strip().find(".")

    if sliceStrSlash != -1:
        videoId = file_key_name.strip()[
                  sliceStrSlash:sliceStrDot]  # Grabs just the file name ex: "Youtube/file.mp4 -> file"
        folder_name = videoId + "/"
    else:
        videoId = file_key_name.strip()[:sliceStrDot]  # Grabs just the file name ex: "Youtube/file.mp4 -> file"
        folder_name = videoId + "/"

    # Get the url of the video to create a videocapture object
    source_url = "https://" + source_bucket_name + ".s3.amazonaws.com/" + file_key_name
    vidcap = cv2.VideoCapture(source_url)

    # While there is still video to be sliced, slice frames of the video into images
    sec = 0
    frameRate = 1  # //it will capture image each 1 seconds
    count = 1
    success = getFrame(sec, vidcap, count, destination_bucket_name, folder_name)
    while success:
        count = count + 1
        sec = sec + frameRate
        sec = round(sec, 2)
        success = getFrame(sec, vidcap, count, destination_bucket_name, folder_name)

    vidcap.release()

    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    logger.info("Username - pch")
    logger.info("File name '" + file_key_name + "' successfully copied to '" + destination_bucket_name + "'")

    return {
        'statusCode': 200,
        'body': json.dumps('Video sliced to images!')
    }
