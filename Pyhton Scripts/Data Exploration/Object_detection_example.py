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

# Setup detectron2 logger and configuration
cfg = get_cfg()
cfg.merge_from_file(model_zoo.get_config_file("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml"))
cfg.MODEL.ROI_HEADS.SCORE_THRESH_TEST = 0.5  # set the testing threshold for this model
cfg.MODEL.DEVICE = 'cpu'  # Run on CPU
cfg.MODEL.WEIGHTS = model_zoo.get_checkpoint_url("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml")
predictor = DefaultPredictor(cfg)

video_path = 'Data/downloaded_videos/BBIX9FG6kZ0.mp4'

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

        # Predict using detectron2
    outputs = predictor(frame)
    v = Visualizer(frame[:, :, ::-1], MetadataCatalog.get(cfg.DATASETS.TRAIN[0]), scale=1.2)
    v = v.draw_instance_predictions(outputs["instances"].to("cpu"))
    processed_frame = v.get_image()[:, :, ::-1]

    # Display the processed frame
    cv.imshow('Detected Objects', processed_frame)
    if cv.waitKey(1) & 0xFF == ord('q'):  # Press 'q' to quit
        break

# Release the video capture object
cap.release()
cv.destroyAllWindows()