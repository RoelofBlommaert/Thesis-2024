import os
import pandas as pd
from pytube import YouTube

path = 'Data/youtube_cleaned.csv'
df = pd.read_csv(path)
print(df)

# List of YouTube video IDs
video_ids = list(df['id'])

#With the IDs, we will create some video urls
video_urls = []
for id in video_ids:
    video_url = 'https://www.youtube.com/watch?v=' + id
    video_urls.append(video_url)

# Directory to save the downloaded videos
save_path = 'Data/downloaded_videos'
if not os.path.exists(save_path):
    os.makedirs(save_path)

# Download each video
for url in video_urls:
    try:
        yt = YouTube(url)
        # Select the highest resolution stream available
        stream = yt.streams.filter(progressive=True, file_extension='mp4', res='720p').first()
        if stream:
            # Download the video and save it with the title of the video
            video_id = yt.video_id
            filename = f"{video_id}.mp4"  # Create filename using the video ID
            stream.download(output_path=save_path, filename=filename)
            print(f"Downloaded: {yt.title} as {filename}")
        else:
            print(f"No suitable stream found for {url}")
    except Exception as e:
        print(f"Failed to download {url}: {str(e)}")

print("All downloads completed.")


#Check what files are not downloaded due to an error or other YouTube restrictions
folder_path = 'Data/downloaded_videos'
file_ids = os.listdir(folder_path)
ids = []
#Remove the .mp4 from the file name
for id in file_ids:
    name = id[:-4]
    ids.append(name)

for identifier in list(df['id']):
    if identifier not in ids:
        print(identifier)
    
