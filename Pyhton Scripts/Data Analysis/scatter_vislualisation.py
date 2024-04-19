import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

visual_path = 'Data/visual_feature_matrix.csv'
youtube_path = 'Data/youtube_cleaned.csv'
final_path = 'Data/Final_feature_matrix.csv'
visual = pd.read_csv(visual_path)
youtube = pd.read_csv(youtube_path)
merged = visual.merge(youtube, left_on='Video Name', right_on='id', how='outer')

# Define the independent variables and dependent variables
iv_columns = ['Color Complexity', 'Edge Density', 'Luminance Complexity']
dv_columns = ['viewCount', 'likeCount', 'commentCount']  # Replace with actual DV column names

# Create 3x3 subplots
fig, axes = plt.subplots(3, 3, figsize=(15, 15))

# Loop through IVs and DVs to create scatter plots
for i, dv in enumerate(dv_columns):
    for j, iv in enumerate(iv_columns):
        sns.scatterplot(data=merged, x=iv, y=dv, ax=axes[i, j])
        axes[i, j].set_xlabel(iv)
        axes[i, j].set_ylabel(dv)

# Adjust layout
plt.tight_layout()
plt.show()
