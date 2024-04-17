import cv2 as cv
import numpy as np
import pandas as pd
import os

#Since the calculation of visual variety demands a different manner of looping and comparing frames, instead of measuring
#independent scores based on one frame at a time, the visual variety calculations are seperate from the functions and main script

   # Beforte runnig this file, make sure that the following conditions are met:
#   1.`Video_functions.py` file is properly installed in the same directory and ran beforehand
#   2. The folder `Videos`is in the same directory
#   3. The document `Video directories` is in the same directory
#   4. The main function is ran in a dedicated terminal, since there is a lot of processing required which can be too demanding
#      for an Interactive Shell leading to functions being distorted when read by the interpreter.          

def convert_and_normalise(frame):
    g_scale = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
    x_min, x_max = np.min(g_scale), np.max(g_scale)
    normalised = (g_scale - x_min) / (x_max - x_min) if x_max - x_min > 0 else np.zeros(g_scale.shape)
    return normalised

def calculate_visual_variety(video_path):
    cap = cv.VideoCapture(video_path)
    if not cap.isOpened():
        print(f"Error: Could not open video {video_path}.")
        return None
    
    total_frames = int(cap.get(cv.CAP_PROP_FRAME_COUNT))
    interval = total_frames // 10
    distances = []
    norm_old_frame = None
    
    for i in range(10):
        frame_pos = i * interval
        cap.set(cv.CAP_PROP_POS_FRAMES, frame_pos)
        ret, frame = cap.read()
        if not ret:
            continue
        norm_frame = convert_and_normalise(frame)
        if norm_old_frame is not None:
            distance = np.sum(np.abs(norm_frame - norm_old_frame)) / norm_frame.size
            distances.append(distance)
        norm_old_frame = norm_frame
    
    cap.release()
    return np.mean(distances) if distances else 0

# Directory containing video files
video_dir = 'Data/downloaded_videos'
video_files = [os.path.join(video_dir, f) for f in os.listdir(video_dir) if f.endswith('.mp4')]

# Dictionary to store video names and their visual variety scores
visual_variety_scores = {}

# Calculate visual variety scores for each video
for video_path in video_files:
    video_name = os.path.basename(video_path)
    score = calculate_visual_variety(video_path)
    if score is not None:
        visual_variety_scores[video_name] = score
        print(f"Visual Variety Score for {video_name}: {score}")

print(visual_variety_scores)
# Read existing CSV file with visual complexity scores
df_complexity = pd.read_csv('Data/video_analysis_complexity_results.csv')

# Convert the visual variety dictionary to a DataFrame
df_variety = pd.DataFrame(list(visual_variety_scores.items()), columns=['Video Name', 'Visual Variety'])
df_variety['Video Name'] = df_variety['Video Name'].str.replace('.mp4', '', regex=False)
# Merge the DataFrames on video name
merged_df = df_complexity.merge(df_variety, on='Video Name', how='outer')

# # Save the updated DataFrame to CSV
merged_file_path = 'Data/complexity_and_variety_scores.csv'
merged_df.to_csv(merged_file_path, index=False)