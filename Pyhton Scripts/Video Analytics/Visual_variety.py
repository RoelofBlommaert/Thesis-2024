import cv2 as cv
import numpy as np
import pandas as pd
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

# Path to the video file
video_path = 'This is Off the Wall.mp4'

# Create a VideoCapture object
cap = cv.VideoCapture(video_path)

# Check if video opened successfully
if not cap.isOpened():
    print("Error: Could not open video.")
    exit()

# Get total number of video frames
total_frames = int(cap.get(cv.CAP_PROP_FRAME_COUNT))

# Calculate interval to sample 30 frames evenly throughout the video
interval = total_frames // 10

# Initialize lists to store the scores
distances = []
norm_old_frame = None
# Loop over 30 frames
for i in range(10):
    # The frame position to read
    frame_pos = i * interval
    
    # Set the current frame position of the video file
    cap.set(cv.CAP_PROP_POS_FRAMES, frame_pos)
    
    # Read the frame
    ret, frame = cap.read()
    # If frame is read correctly ret is True
    if not ret:
        print("Failed to grab frame.")
        continue  # Skip this frame and continue with the next
    norm_frame = convert_and_normalise(frame)
    if norm_old_frame is not None:
        distance = np.sum(np.abs(norm_frame - norm_old_frame)) / norm_frame.size
        distances.append(distance)
    norm_old_frame = norm_frame

visual_variety_score = np.mean(distances)
print("Visual Variety Score:", visual_variety_score)
