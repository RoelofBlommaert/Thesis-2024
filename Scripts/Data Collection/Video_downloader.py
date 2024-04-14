import os
from pytube import YouTube


# List of YouTube video URLs
video_urls = [
    
]

# Directory to save the downloaded videos
save_path = 'downloaded_videos'

# Ensure the directory exists
if not os.path.exists(save_path):
    os.makedirs(save_path)

# Download each video
for url in video_urls:
    try:
        yt = YouTube(url)
        # Select the highest resolution stream available
        stream = yt.streams.filter(progressive=True, file_extension='mp4').order_by('resolution').desc().first()
        if stream:
            # Download the video and save it with the title of the video
            stream.download(output_path=save_path, filename=f"{yt.title}.mp4")
            print(f"Downloaded: {yt.title}")
        else:
            print(f"No suitable stream found for {url}")
    except Exception as e:
        print(f"Failed to download {url}: {str(e)}")

print("All downloads completed.")
