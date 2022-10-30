# importing the module 
from pytube import YouTube 
import os
from pathlib import Path

# where to save 

url = YouTube('https://www.youtube.com/watch?v=T7kklmGWLDk')
# link of the video to be downloaded 
link="https://www.youtube.com/watch?v=xWOoBJUqlbI"
  
video = url.streams.get_highest_resolution()

path_to_download_folder = str(os.path.join(Path.home(), "Downloads"))

video.download(path_to_download_folder)
print("Downloaded! :)")
