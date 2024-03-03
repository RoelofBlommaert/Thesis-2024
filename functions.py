import cv2 as cv
import numpy as np

def calculate_colour_complexity(frame):
    # Convert the frame to CieLab color space
    CieLab = cv.cvtColor(frame, cv.COLOR_BGR2Lab)
    
    # Split the CieLab image into L*, a*, and b* channels
    L, a, b = cv.split(CieLab)
    
    # Calculate the mean Chroma
    Chroma = np.sqrt(np.square(a) + np.square(b))
    mean_Chroma = np.mean(Chroma)
    
    # Calculate the standard deviation of a* and b*
    std_dev_a = np.std(a)
    std_dev_b = np.std(b)
    
    # Calculate the colour complexity
    Colour_complexity = 0.94 * (mean_Chroma + np.sqrt(std_dev_a**2 + std_dev_b**2))
    
    return Colour_complexity

def calculate_edge_ratio(frame):
    # Convert frame to grayscale
    gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
    
    # Apply Canny edge detection
    edges = cv.Canny(gray, 100, 200)  # Adjust thresholds as needed
    
    # Calculate the ratio of edge pixels to total pixels
    edge_pixels = np.sum(edges > 0)
    total_pixels = frame.shape[0] * frame.shape[1]
    edge_ratio = edge_pixels / total_pixels
    
    return edge_ratio

def calculate_luminance_entropy(frame):
    # Convert the frame from RGB to YUV
    YUV = cv.cvtColor(frame, cv.COLOR_BGR2YUV)
    Y = YUV[:,:,0]  # Extract the Y channel (luminance)
    
    # Calculate the histogram of luminance values
    hist, _ = np.histogram(Y, bins=256, range=(0, 256))
    
    # Normalize the histogram to get probabilities (nj/N)
    prob = hist / np.sum(hist)
    
    # Filter out zero probabilities to avoid log(0)
    prob_nonzero = prob[prob > 0]
    
    # Calculate luminance entropy
    luminance_entropy = -np.sum(prob_nonzero * np.log2(prob_nonzero))
    
    return luminance_entropy

# Example usage
# Assuming you have a frame from your video
# frame = <your_frame_here>
# entropy = calculate_luminance_entropy(frame)
# print("Luminance Entropy:", entropy)