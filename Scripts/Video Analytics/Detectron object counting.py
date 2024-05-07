import cv2 as cv
import detectron2
from detectron2.utils.logger import setup_logger
setup_logger()
# Import some common detectron2 utilities
from detectron2 import model_zoo
from detectron2.engine import DefaultPredictor
from detectron2.config import get_cfg
from detectron2.utils.visualizer import Visualizer
from detectron2.data import MetadataCatalog, DatasetCatalog
import os
import numpy as np
import pandas as pd

# Setup detectron2 logger and configuration
cfg = get_cfg()
cfg.merge_from_file(model_zoo.get_config_file("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml"))
cfg.MODEL.ROI_HEADS.SCORE_THRESH_TEST = 0.5  # set the testing threshold for this model
cfg.MODEL.DEVICE = 'cpu'  # Run on CPU
cfg.MODEL.WEIGHTS = model_zoo.get_checkpoint_url("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml")
predictor = DefaultPredictor(cfg)

def detect_and_return_unique_objects(frame):
    outputs = predictor(frame)
    instances = outputs["instances"].to("cpu")
    classes = instances.pred_classes
    scores = instances.scores
    labels = [MetadataCatalog.get(cfg.DATASETS.TRAIN[0]).thing_classes[i] for i in classes]
    unique_labels = {label for label, score in zip(labels, scores) if score > 0.5}
    return len(unique_labels)

def calculate_unique_objects(video_path):
    cap = cv.VideoCapture(video_path)
    if not cap.isOpened():
        print(f"Error: Could not open video {video_path}.")
        return None
    
    total_frames = int(cap.get(cv.CAP_PROP_FRAME_COUNT))
    interval = total_frames // 30  # Process 30 frames evenly distributed throughout the video
    cum_unique_objects = 0
    
    for i in range(30):
        frame_pos = i * interval
        cap.set(cv.CAP_PROP_POS_FRAMES, frame_pos)
        ret, frame = cap.read()
        if not ret:
            continue
        unique_objects = detect_and_return_unique_objects(frame)
        cum_unique_objects += unique_objects
    
    cap.release()
    return cum_unique_objects

# Directory containing video files
video_dir = 'Data/downloaded_videos'
video_files = [os.path.join(video_dir, f) for f in os.listdir(video_dir) if f.endswith('.mp4')]

# Dictionary to store video names and their sum of unique objects over 30 frames
unique_objects_counts = {}

# Calculate unique objects for each video
for video_path in video_files:
    video_name = os.path.basename(video_path)
    count = calculate_unique_objects(video_path)
    if count is not None:
        unique_objects_counts[video_name] = count
        print(f"Unique objects count for {video_name}: {count}")

# Convert the unique objects dictionary to a DataFrame
df_unique_objects = pd.DataFrame(list(unique_objects_counts.items()), columns=['Video Name', 'Unique Objects Count'])
df_unique_objects['Video Name'] = df_unique_objects['Video Name'].str.replace('.mp4', '', regex=False)
df_unique_objects['Unique Objects Count'] = df_unique_objects['Unique Objects Count']/30
df_complexity_variety = pd.read_csv('Data/complexity_and_variety_scores.csv')

# Merge the DataFrames on video name
merged_df = df_complexity_variety.merge(df_unique_objects, on='Video Name', how='outer')

# # Save the updated DataFrame to CSV
merged_file_path = 'Data/visual_feature_matrix.csv'
merged_df.to_csv(merged_file_path, index=False)

# Save the DataFrame to CSV
df_unique_objects.to_csv('Data/unique_objects_counts.csv', index=False)


