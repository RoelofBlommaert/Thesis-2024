import cv2 as cv
import detectron2
from detectron2.utils.logger import setup_logger
setup_logger()
# Import some common detectron2 utilities
from detectron2 import model_zoo
from detectron2.engine import DefaultPredictor
from detectron2.config import get_cfg
from detectron2.utils.visualizer import Visualizer
from detectron2.data import MetadataCatalog

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
    return unique_labels

video_path = "First-Timer _ Apple Vision Pro.mp4"

# Initialize a set to store cumulative unique objects detected across frames
cum_unique_objects = set()

# Open the video
cap = cv.VideoCapture(video_path)
if not cap.isOpened():
    print("Error: Could not open video.")
    exit()
# Calculate the interval for sampling 30 frames
total_frames = int(cap.get(cv.CAP_PROP_FRAME_COUNT))
interval = max(1, total_frames // 30)  # Avoid division by zero

# Process 30 frames evenly distributed throughout the video
for i in range(30):
    # Set the frame position
    frame_id = i * interval
    cap.set(cv.CAP_PROP_POS_FRAMES, frame_id)
    
    # Read the frame
    ret, frame = cap.read()
    if not ret:
        break  # No more frames to process or unable to read the frame

    # Detect and return unique labels for the current frame
    frame_unique_labels = detect_and_return_unique_objects(frame)
    # Update the cumulative set of unique objects
    cum_unique_objects.update(frame_unique_labels)

# Release the video capture object
cap.release()

# Print the cumulative unique objects detected
print("Unique objects detected across sampled frames:")
print(cum_unique_objects)
print("Count of unique objects detected across samples frames:")
print(len(cum_unique_objects))