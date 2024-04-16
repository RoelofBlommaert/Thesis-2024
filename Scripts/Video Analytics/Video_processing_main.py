import cv2 as cv
import numpy as np
import pandas as pd
import Video_functions

# Beforte runnig this file, make sure that the following conditions are met:
#   1.`Video_functions.py` file is properly installed in the same directory and ran beforehand
#   2. The folder `Videos`is in the same directory
#   3. The document `Video directories` is in the same directory
#   4. The main function is ran in a dedicated terminal, since there is a lot of processing required which can be too demanding
#      for an Interactive Shell leading to functions being distorted when read by the interpreter          

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
interval = total_frames // 30

# Initialize lists to store the scores
colour_complexity_scores = []
edge_ratio_scores = []
luminance_entropy_scores = []
object_asymmetry_scores = []
# Loop over 30 frames
for i in range(30):
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
    
    # Calculate metrics
    colour_complexity = Video_functions.calculate_colour_complexity(frame)
    edge_ratio = Video_functions.calculate_edge_ratio(frame)
    luminance_entropy = Video_functions.calculate_luminance_entropy(frame)
    object_asymmetry = Video_functions.calculate_asymmetry(frame)
    # Store the scores
    colour_complexity_scores.append(colour_complexity)
    edge_ratio_scores.append(edge_ratio)
    luminance_entropy_scores.append(luminance_entropy)
    object_asymmetry_scores.append(object_asymmetry)



# Calculate the mean of the scores
mean_colour_complexity = np.mean(colour_complexity_scores)
mean_edge_ratio = np.mean(edge_ratio_scores)
mean_luminance_entropy = np.mean(luminance_entropy_scores)
mean_object_asymmetry = np.mean(object_asymmetry_scores)

# Create a DataFrame with the results
df = pd.DataFrame({"Colour Complexity": [mean_colour_complexity], "Edge Ratio": [mean_edge_ratio],
"Luminance Entropy": [mean_luminance_entropy], "Asymmetry of Object Arrangement": [mean_object_asymmetry]
})

# Display the DataFrame
print(df)

# Release the video capture object and close windows
cap.release()
cv.destroyAllWindows()
