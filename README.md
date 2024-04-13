Hi there!

This repository is meant for my thesis in marketing Management '24. In this repo, I will share the data used for the YouTube API calls, the raw data sourced using the YouTube data API, and all code used for data collection, variable measurement, analysis and visualisation.

# In this repo you will find:

## 1. Python files that are meant for video analysis, data visualization and main regression analysis

[Video functions.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Video_functions.py) is a file that consists of all feature complexity function definitions and asymmetry of object arrangement.

[Video_processing_main.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Video_processing_main.py) is a file that calls the `Video_processing_main.py` file and loops through the 30 frames of the video.

[Detectron object counting.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Detectron%20object%20counting.py) is a file that calls the `Detectron object counting.py` file, individually loops through the videos and saves the unique labels of objects detected and the unique object count. This file loops through the videos individually since the dependencies and computational power necessary for the detectron2 package can cause errors frequently. Isolating the package in one file makes this more manageable.

[Irregularity.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Irregularity.py) is a file that calls the `Irregularity.py` file, individually loops through the videos and saves the score for irregularity of object arrangement.

[Visual_variety.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Visual_variety.py) is a file that calls the `Visual_variety.py.py` file, individually loops through the videos and saves the score for irregularity of object arrangement.

## 2. API interaction script for data gathering
[Youtube_pull.py](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Youtube_pull.py) which is the ingestion script for video links and calls the API. It creates the YouTube data file with Independent, dependent and control variables from the YouTube API.

## 3. Data files
[Video_links.xlsx](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Video_links.xlsx) contains video links gathered from https://www.superbowl-ads.com/ for the years 2020 - 2024, with the Youtube Channel name and Brand name included. These links have been manually checked to be original uploads.

A folder with downloaded mp.4 videos, which is a list of downloaded YouTube videos that will be ingested by the `video_processing_main.py`, `Detectron object counting.py`, `Visual_variety.py.py` and `Irregularity.py` scripts for further analysis.

[Superbowl_data_2024.csv](https://github.com/RoelofBlommaert/Thesis-2024/blob/main/Superbowl_data_2024.csv) contains the results of pulling the data from Youtube using the API. This file contains both the dependent variables, as well as some control variables.

[Name] consists of the visual video data variables per video, with the title of the video included.

[Final Feature Matrix] is a feature matrix file with all variables from the Youtube API, as well as the calculated visual variables. This is the result of combining `Superbowl_data_2024.cs` and `[Name] files on video title.

