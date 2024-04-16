Hi there! 😄

This research leverages computer vision and object detection to measure the effect of low-level visual features in advertising videos on online engagement metrics. 

In this repo, all data and scripts used for data collection, exploration and analysis and video analytics, will be shared.

The files in this repository are split up into two folders:
1. Data
2. Scripts

The folders have the following contents

# 1. Scripts

## a. Data collections
1. [Youtube_Video_pull.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Data%20Collection/Youtube_Video_pull.py). This script fetches video data using the URLs in `video_links.xlsx`  using the YouTube Data API and creates `youtube_videos_raw.csv`.
  
2. [YouTube_channel_pull.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Data%20Collection/YouTube_channel_pull.py). This script fetches the channel subscribers using the YouTube Data API and creates `youtube_channels_videos_raw.csv` by merging video and channel data into one raw data file.

3. [YouTube_downloader.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Data%20Collection/Video_downloader.py). This script downloads videos based on the id's in `youtube_cleaned.csv` automatically and places data into `downloaded_videos`.

## b. Video analytics
1. [Video functions.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Video%20Analytics/Video_functions.py) is a file that consists of all feature complexity function definitions and asymmetry of object arrangement.

2. [Video_processing_main.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Video%20Analytics/Video_processing_main.py) is a file that calls the `Video_processing_main.py` file and loops through the 30 frames of the video.

3. [Detectron object counting.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Video%20Analytics/Detectron%20object%20counting.py) is a file that calls the `Detectron object counting.py` file, individually loops through the videos and saves the unique labels of objects detected and the unique object count. This file loops through the videos individually since the dependencies and computational power necessary for the detectron2 package can cause errors frequently. Isolating the package in one file makes this more manageable.

4. [Irregularity.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Video%20Analytics/Irregularity.py) is a file that calls the `Irregularity.py` file, individually loops through the videos and saves the score for irregularity of object arrangement.

5. [Visual_variety.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Video%20Analytics/Visual_variety.py) is a file that calls the `Visual_variety.py.py` file, individually loops through the videos and saves the score for irregularity of object arrangement.

## c. Data exploration
1. [Data_cleaning.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Data%20Exploration/Data_cleaning.py) is a script that deletes videos that have missing values for any of the dependent variables, re-calculated some variables (duration and time) and performs some data exploration for sample characteristics.


## d. Data analysis


## 2. Data

1. [Video_links.xlsx](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Video_links.xlsx) contains video links gathered from https://www.superbowl-ads.com/ for the years 2020 - 2024, with the Youtube Channel name and Brand name included. These links have been manually checked to be original uploads.

2. [youtube_videos_raw.csv](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Data/youtube_videos_raw.csv) contains the results of pulling the video data from Youtube using the API. This file contains both the dependent variables, as well as some control variables.

3. [youtube_channels_videos_raw.csv](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Data/youtube_channels_videos_raw.csv) consists of all the YouTube-related data per video. It is the raw data file.

4. [youtube_cleaned.csv](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Data/youtube_cleaned.csv) contains only the data without missing dependent variables. This is the final YouTube data file.

