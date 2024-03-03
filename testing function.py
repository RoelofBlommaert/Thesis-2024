import cv2 as cv
import numpy as np
import pandas as pd
import functions

# Assuming the functions calculate_colour_complexity, calculate_edge_ratio,
# and calculate_luminance_entropy are already defined

# Path to the video file
video_path = '/Users/roelofblommaert/Library/CloudStorage/OneDrive-Personal/Thesis 23 - 34/Videos/First-Timer _ Apple Vision Pro.mp4'

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
    colour_complexity = functions.calculate_colour_complexity(frame)
    edge_ratio = functions.calculate_edge_ratio(frame)
    luminance_entropy = functions.calculate_luminance_entropy(frame)
    
    # Store the scores
    colour_complexity_scores.append(colour_complexity)
    edge_ratio_scores.append(edge_ratio)
    luminance_entropy_scores.append(luminance_entropy)

# Calculate the mean of the scores
mean_colour_complexity = np.mean(colour_complexity_scores)
mean_edge_ratio = np.mean(edge_ratio_scores)
mean_luminance_entropy = np.mean(luminance_entropy_scores)

# Create a DataFrame with the results
df = pd.DataFrame({
    "Colour Complexity": [mean_colour_complexity],
    "Edge Ratio": [mean_edge_ratio],
    "Luminance Entropy": [mean_luminance_entropy]
})

# Display the DataFrame
print(df)

# Release the video capture object and close windows
cap.release()
cv.destroyAllWindows()
