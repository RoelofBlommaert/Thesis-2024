from googleapiclient.discovery import build
import pandas as pd 
import seaborn as sns
import os
api_key = os.getenv("MY_SECRET_KEY")
tryout = 'vQ88JB-lgtQ'

print(os.getenv("MY_SECRET_KEY"))

youtube = build('youtube', 'v3', developerKey=api_key)


# Define the file path to the Excel file
file_path = 'Video_links.xlsx'

# Read the Excel file into a pandas DataFrame
df = pd.read_excel(file_path)

for i in df['Video_id']:
    url_parts = i.split('?v=')[1]
    API_ID=url_parts[0:11]
    print(API_ID)
