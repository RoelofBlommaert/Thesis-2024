Hi there!

This repository is meant for my thesis in marketing Management '24. In this repo, I will share the data used for the YouTube API calls, the raw data sourced using the YouTube data API, and all code used for data collection, variable measurement, analysis and visualisation.

# In this repo you will find:

## 1. Python files that are meant for video analysis, data visualization and main regression analysis

[Video functions.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Video_functions.py) is a file that consists of all feature complexity function definitions and asymmetry of object arrangement.

[Video_processing_main.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Video_processing_main.py) is a file that calls the `Video_processing_main.py` file and loops through the 30 frames of the video.

[Detectron object counting.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Detectron%20object%20counting.py) is a file that calls the `Detectron object counting.py` file, individually loops through the videos and saves the unique labels of objects detected and the unique object count. This file loops through the videos individually since the dependencies and computational power necessary for the detectron2 package can cause errors frequently. Isolating the package in one file makes this more manageable.

[Irregularity.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Irregularity.py) is a file that calls the `Irregularity.py` file, individually loops through the videos and saves the score for irregularity of object arrangement.

[Visual_variety.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Visual_variety.py) is a file that calls the `Visual_variety.py.py` file, individually loops through the videos and saves the score for irregularity of object arrangement.

## 2. A .xlsx file with all video links of original YouTube video links called [Video_links.xlsx](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Video_links.xlsx).
This file also includes YouTube channel name and brand name. These videos have been manually checked to be original uploads form the official brand channel. 

## 3. A folder with downloaded mp.4 videos, which is a list of downloaded YouTube videos that will be ingested by the `video_processing_main.py`, `Detectron object counting.py`, `Visual_variety.py.py` and `Irregularity.py` scripts for further analysis.

## 4. [Youtube_pull.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Youtube_pull.py) which is the ingestion script for video links and calls the API. It creates the YouTube data file with Independent, dependent and control variables from the YouTube API.

## 5. [Superbowl_data_2024.csv](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Superbowl_data_2024.csv) which contains the raw Youtube data, which consists of dependent variables and control variables gathered with the Youtube API.

## 6. Video data, consisting of the measures for visual complexity and visual variety scores for each video.

## 7. A total feature matrix file, which has all Youtube and Video data in a combined file for regression analysis.

