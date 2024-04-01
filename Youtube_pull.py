import pandas as pd
import os
from googleapiclient.discovery import build

# Function to chunk a list into smaller lists
def chunk_list(lst, chunk_size):
    for i in range(0, len(lst), chunk_size):
        yield lst[i:i + chunk_size]

# Read the Excel file to extract video IDs
file_path = 'Video_links.xlsx'
df = pd.read_excel(file_path)

# Extract video IDs from the DataFrame
video_ids = [url.split('?v=')[1][0:11] for url in df['Link']]

# Set up the YouTube Data API
api_key = os.getenv("MY_SECRET_KEY")
youtube = build('youtube', 'v3', developerKey=api_key)

# Chunk the list of video IDs into smaller lists
chunk_size = 50
video_id_chunks = list(chunk_list(video_ids, chunk_size))

# Initialize an empty list to store the API responses
all_responses = []

# Make API requests for each chunk of video IDs
# for chunk in video_id_chunks:
#     video_ids_string = ",".join(chunk)
#     request = youtube.videos().list(
#         part='snippet,contentDetails,statistics',
#         id=video_ids_string
#     )
#     response = request.execute()
#     all_responses.append(response)


flattened_data = []

# Iterate through each response in all_responses
for response in all_responses:
    # Extract the items from the response
    items = response.get('items', [])
    for item in items:
        # Flatten the JSON structure
        flattened_item = {
            'id': item['id'],
            'publishedAt': item['snippet']['publishedAt'],
            'channelId': item['snippet']['channelId'],
            'title': item['snippet']['title'],
            'channelTitle': item['snippet']['channelTitle'],
            'tags': item['snippet'].get('tags', []),
            'categoryId': item['snippet']['categoryId'],
            'duration': item['contentDetails']['duration'],
            'viewCount': item['statistics']['viewCount'],
            'likeCount': item['statistics']['likeCount'],
            'commentCount': item['statistics'].get('commentCount', None)  # Set to None if not present
        }
        # Append the flattened dictionary to the list
        flattened_data.append(flattened_item)

# Create a DataFrame from the flattened data
df = pd.DataFrame(flattened_data)

# Display the DataFrame
print(df)

#df.to_csv('Superbowl_data_2024.csv', index=False)
