import pandas as pd
import os
from googleapiclient.discovery import build

# Function to chunk a list into smaller lists
def chunk_list(lst, chunk_size):
    for i in range(0, len(lst), chunk_size):
        yield lst[i:i + chunk_size]

# Read the Excel file to extract channel IDs
file_path = 'Superbowl_video_data.csv'
video_df = pd.read_csv(file_path)

# Extract video IDs from the DataFrame
channel_ids = video_df['channelId'].unique()

# Set up the YouTube Data API
api_key = os.getenv("MY_SECRET_KEY")
youtube = build('youtube', 'v3', developerKey=api_key)

# Chunk the list of video IDs into smaller lists
chunk_size = 50
channel_id_chunks = list(chunk_list(channel_ids, chunk_size))

# Initialize an empty list to store the API responses
all_responses = []

# Make API requests for each chunk of video IDs
for chunk in channel_id_chunks:
    channel_ids_string = ",".join(chunk)
    request = youtube.channels().list(
        part='statistics',
        id=channel_ids_string
    )
    response = request.execute()
    all_responses.append(response)


flattened_data = []

# Iterate through each response in all_responses
for response in all_responses:
    # Extract the items from the response
    items = response.get('items', [])
    for item in items:
        # Flatten the JSON structure
        flattened_item = {
            'channelId': item['id'],
            'subscriberCount': item['statistics'].get('subscriberCount', '0')  # Default to '0' if not present
        }
        # Append the flattened dictionary to the list
        flattened_data.append(flattened_item)

# Create a DataFrame from the flattened data
df = pd.DataFrame(flattened_data)

# Display the DataFrame
print(df)

#Merging so subscriber count is added to the final data
merged_df = pd.merge(video_df, df, on='channelId', how='left')

# Save the merged DataFrame back to a CSV
merged_df.to_csv('Superbowl_data_Final.csv', index=False)

# Print or inspect the merged DataFrame to confirm
print(merged_df.head())

