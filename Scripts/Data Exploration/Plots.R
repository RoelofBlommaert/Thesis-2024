# Install and load necessary libraries
if (!require(ggplot2)) install.packages("ggplot2", dependencies=TRUE)
if (!require(GGally)) install.packages("GGally", dependencies=TRUE)
library(ggplot2)
library(GGally)

# Load data from CSV file
# Replace 'your_data.csv' with the path to your CSV file
data <- read.csv('Data/feature_matrix.csv')

# Define the columns that are the DVs you want to plot
dv_columns <- c("viewCount", "likeCount", "commentCount")

# Subset the data to include only the DVs
dv_data <- data[dv_columns]

# Create individual histograms with kernel density plot

# Histogram for viewCount with adjusted bins
p1 <- ggplot(dv_data, aes(x = viewCount)) +
  geom_histogram(aes(y = ..density..), bins = 100, fill = "grey", alpha = 0.7) +  # Adjusted bins
  geom_density(color = "black", alpha = 0.7) +
  labs(x = "View Count", y = "Density") +
  theme_minimal(base_size = 12) +
  theme(panel.background = element_rect(fill = "white", color = NA),
        plot.background = element_rect(fill = "white", color = NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

# Histogram for likeCount with adjusted bins
p2 <- ggplot(dv_data, aes(x = likeCount)) +
  geom_histogram(aes(y = ..density..), bins = 100, fill = "grey", alpha = 0.7) +  # Adjusted bins
  geom_density(color = "black", alpha = 0.7) +
  labs(x = "Like Count", y = "Density") +
  theme_minimal(base_size = 12) +
  theme(panel.background = element_rect(fill = "white", color = NA),
        plot.background = element_rect(fill = "white", color = NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

# Histogram for commentCount with adjusted bins
p3 <- ggplot(dv_data, aes(x = commentCount)) +
  geom_histogram(aes(y = ..density..), bins = 100, fill = "grey", alpha = 0.7) +  # Adjusted bins
  geom_density(color = "black", alpha = 0.7) +
  labs(x = "Comment Count", y = "Density") +
  theme_minimal(base_size = 12) +
  theme(panel.background = element_rect(fill = "white", color = NA),
        plot.background = element_rect(fill = "white", color = NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

# Display the plots separately
print(p1)
print(p2)
print(p3)
