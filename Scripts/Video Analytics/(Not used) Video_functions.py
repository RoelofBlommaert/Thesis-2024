
import cv2 as cv
import numpy as np
from skimage.transform import pyramid_gaussian


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

def calculate_asymmetry(frame):
    # Convert the frame to CieLab color space
    CieLab = cv.cvtColor(frame, cv.COLOR_BGR2Lab)
    L_channel = CieLab[:, :, 0]  # Luminance channel
    pyramid = list(pyramid_gaussian(L_channel, max_layer=3, downscale=2))
    # For simplicity, use the first level of the pyramid as the clutter map
    clutter_map = pyramid[0]
    if len(pyramid) > 1:
        for level in range(1, len(pyramid)):
            clutter_level = pyramid[level]
            # Ensure the shapes match for maximum comparison
            min_shape = (min(clutter_map.shape[0], clutter_level.shape[0]), min(clutter_map.shape[1], clutter_level.shape[1]))
            clutter_map = np.maximum(clutter_map[:min_shape[0], :min_shape[1]], clutter_level[:min_shape[0], :min_shape[1]])
    
    m, n = clutter_map.shape
    horz = np.sum([np.sqrt((clutter_map[j,i] - clutter_map[m-j-1,i])**2) for i in range(n) for j in range(m//2)])
    ah = horz / (m*n/2)  # Horizontal asymmetry

    vert = np.sum([np.sqrt((clutter_map[i,j] - clutter_map[i,n-j-1])**2) for i in range(m) for j in range(n//2)])
    av = vert / (m*n/2)  # Vertical asymmetry

    # Calculate the mean of vertical and horizontal asymmetry
    asymmetry_mean = (ah + av) / 2

    return asymmetry_mean

def calculate_visual_variety(frame):
    g_scale = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
    normalized_frame = g_scale / 255.0
    



