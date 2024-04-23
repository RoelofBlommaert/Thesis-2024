import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load your data
visual_path = 'Data/visual_feature_matrix.csv'
youtube_path = 'Data/youtube_cleaned.csv'
final_path = 'Data/Final_feature_matrix.csv'
visual = pd.read_csv(visual_path)
youtube = pd.read_csv(youtube_path)
merged = visual.merge(youtube, left_on='Video Name', right_on='id', how='outer')

merged.to_csv('Data/feature_matrix.csv', index=False)
# Define the independent and dependent variables
iv_columns = ['Color Complexity', 'Edge Density', 'Luminance Complexity']
dv_columns = ['likeCount']  # Replace with actual DV column names

# Normalize independent variables using min-max normalization
for iv in iv_columns:
    merged[iv] = (merged[iv] - merged[iv].min()) / (merged[iv].max() - merged[iv].min())

# Create scatter plots with percentile markers and quadratic curve fits
fig, axes = plt.subplots(1, 3, figsize=(18, 5))

for i, iv in enumerate(iv_columns):
    ax = axes[i]
    x = merged[iv]
    y = merged[dv_columns[0]]  # Assuming only one dependent variable for simplicity
    
    # Scatter plot
    ax.scatter(x, y, s=25)
    ax.set_xlabel(iv)
    ax.set_ylabel(dv_columns[0])
    
    # Calculate percentiles
    percentiles = np.percentile(x, [1, 25, 50, 75, 99])
    
    # Plot percentile markers
    for percentile in percentiles:
        y_percentile = np.interp(percentile, x, y)
        ax.plot(percentile, y_percentile, marker='o', markersize=8, color='red', linestyle='None')
    
    # Fit quadratic curve
    coeffs = np.polyfit(x, y, 2)
    poly = np.poly1d(coeffs)
    x_fit = np.linspace(min(x), max(x), 100)
    y_fit = poly(x_fit)
    ax.plot(x_fit, y_fit, color='blue')

# Add legend for percentile markers
axes[0].legend(['1st', '25th', '50th', '75th', '99th'], loc='upper left')

plt.tight_layout()
plt.show()
