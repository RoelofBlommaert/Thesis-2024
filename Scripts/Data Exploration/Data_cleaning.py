import pandas as pd
import numpy as np
import seaborn as sns
from datetime import datetime

path = 'Data/youtube_channels_videos_raw.csv'
df = pd.read_csv(path)

#Find which dependent variable does not have data available for views, likes or comments and count values
na_counts = df[['likeCount', 'viewCount', 'commentCount']].isna().sum()
print(na_counts)

#Create cleaned dataset with no missing values for the DV's
df_cleaned = df.dropna(subset=['likeCount', 'viewCount', 'commentCount'])
print (df_cleaned)

#Counting the number of uniquq channels
df_cleaned['channelTitle'].nunique()

#Counting videos per year
df_cleaned['publishedAt'] = pd.to_datetime(df_cleaned['publishedAt']) #Converting to datetime
df_cleaned['year'] = df_cleaned['publishedAt'].dt.year #Adding column called year
# Group by 'year' and 'status', then count the occurrences
status_count_per_year = df_cleaned.groupby('year')['status'].value_counts().unstack(fill_value=0)
#Sort the years
status_count_per_year = status_count_per_year.sort_index()
# Display the count of videos per year, with status breakdown
print(status_count_per_year)

# Group by the 'year' column and calculate the mean for 'views', 'likes', 'comments'
average_metrics_per_year = df_cleaned.groupby('year').agg({
    'viewCount': 'mean',
    'likeCount': 'mean',
    'commentCount': 'mean'
}).sort_index()

# Print the average views, likes, and comments per year
print(average_metrics_per_year)

# Convert 'publishedAt' column to datetime format
df_cleaned['publishedAt'] = pd.to_datetime(df_cleaned['publishedAt'])

# Make current date timezone-aware to match the timezone of 'publishedAt' column
current_date = datetime.now(df_cleaned['publishedAt'].dt.tz)

# Calculate the difference in days
df_cleaned['Time'] = (current_date - df_cleaned['publishedAt']).dt.days

# Print the DataFrame with the new 'Time' variable
print(df_cleaned[['publishedAt', 'Time']])

#Recode duration to be seconds, by recoding ISO8601 strings to seconds
def iso8601_duration_to_seconds(iso_duration):
    parts = iso_duration.strip('PT').split('M')
    mins = int(parts[0] if len(parts) == 2 else 0)
    secs = int(parts[-1].strip('S')) if parts[-1] else 0
    return 60*mins+secs

df_cleaned['Length'] = df_cleaned['duration'].apply(iso8601_duration_to_seconds)

print(df_cleaned)


#Load cleaned data file
cleaned_file_path = 'Data/youtube_cleaned.csv'
df_cleaned.to_csv(cleaned_file_path, index = False)