# The Search for Engaging Ads: A Visual Feature Analysis of Video Advertisements Leveraging Computer Vision

Hi there! 😄

This research leverages computer vision and object detection to measure the effect of low-level visual features in advertising videos on online engagement for Super Bowl advertisements uploaded on YouTube. 

On this repository, all data and scripts used for data collection, exploration, and analysis of both YouTube and video data, will be shared.

The files in this repository are split up into four folders:
1. Data
2. Scripts
3. Helper functions
4. The repository used by ​‌‌‍‍​‍Overgoor, G., Rand, W., Van Dolen, W., & Mazloom, M. (2022). Simplicity is not key: understanding firm-generated social media images and consumer liking. International Journal of Research in Marketing, 39(3), 639–655. https://doi.org/10.1016/j.ijresmar.2021.12.005


The scripts and data folders have the following contents

# 1. Scripts

## a. Data collections
1. [Youtube_Video_pull.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Data%20Collection/Youtube_Video_pull.py). This script fetches video data using the URLs in `video_links.xlsx`  using the YouTube Data API and creates `youtube_videos_raw.csv`.
  
2. [YouTube_channel_pull.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Data%20Collection/YouTube_channel_pull.py). This script fetches the channel subscribers using the YouTube Data API and creates `youtube_channels_videos_raw.csv` by merging video and channel data into one raw data file.

3. [YouTube_downloader.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Data%20Collection/Video_downloader.py). This script downloads videos based on the id's in `youtube_cleaned.csv` automatically and places data into `downloaded_videos`.

## b. Video analytics
1. [Visual Variety.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Video%20Analytics/Video_functions.py) is a file that loops through the video folder and contains all calculations for visual variety.

2. [Detectron object counting.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Video%20Analytics/Detectron%20object%20counting.py) is a file that calls the `Detectron object counting.py` file, individually loops through the videos and saves the unique labels of objects detected and the unique object count. This file loops through the videos individually since the dependencies and computational power necessary for the detectron2 package can cause errors frequently. Isolating the package in one file makes this more manageable.

3. Despite [Visual_complexity_main.m] (https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Visual_complexity_main.m) being in main, it is part of the video analysis procedure, which calculates the measures outlined in Overgoor et al. (2022) for video analysis, and also used the Helper functions/Saliency Toolbox by Rosenholtz et al. (2007).


## c. Data exploration
1. [Data_cleaning.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Data%20Exploration/Data_cleaning.py) is a script that deletes videos that have missing values for any of the dependent variables, re-calculated some variables (duration and time) and performs some data exploration for sample characteristics.

Other files in this folder are for generating example visuals in the paper.

## d. Data analysis
1. [Regression.R](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Scripts/Data%20Analysis/Regression.R) is a script that runs all data analysis procedures named in the paper under section 4. Namely, the regression fitting, multicollinearity analysis, data scaling and normalisation, regression fitting, visualisations and correlation table generation.

2. Other files in the folder are irrelevant to the data analysis.

## 2. Data

The data folder contains modularised .csv files of the output of most scripts, such as the outcome of object counting, the outcome of the video analysis scripts in Python, the outcome of the visual analysis in Matlab, and a combined visual features file. It also contains the links to the raw video links, the result of the channel and video GET requests, and a combined raw feature matrix, and the cleaned and recalculated variants.

Finally, the data also contains some frames or plots for visualisation in the paper. 

