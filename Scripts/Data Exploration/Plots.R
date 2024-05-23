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

# Create histograms with density plots and custom x-axis breaks

# Histogram for viewCount with adjusted x-axis breaks
p1 <- ggplot(dv_data, aes(x = viewCount)) +
  geom_histogram(aes(y = ..density..), bins = 100, fill = "grey", alpha = 0.7) +
  geom_density(color = "black", alpha = 0.7) +
  scale_x_continuous(breaks = seq(0, max(dv_data$viewCount), by = 100000000)) + # Adjust breaks
  labs(x = "View Count", y = "Density") +
  theme_minimal(base_size = 12) +
  theme(panel.background = element_rect(fill = "white", color = NA),
        plot.background = element_rect(fill = "white", color = NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1))

# Histogram for likeCount with default x-axis breaks
p2 <- ggplot(dv_data, aes(x = likeCount)) +
  geom_histogram(aes(y = ..density..), bins = 100, fill = "grey", alpha = 0.7) +
  geom_density(color = "black", alpha = 0.7) +
  labs(x = "Like Count", y = "Density") +
  theme_minimal(base_size = 12) +
  theme(panel.background = element_rect(fill = "white", color = NA),
        plot.background = element_rect(fill = "white", color = NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1))

# Histogram for commentCount with default x-axis breaks
p3 <- ggplot(dv_data, aes(x = commentCount)) +
  geom_histogram(aes(y = ..density..), bins = 100, fill = "grey", alpha = 0.7) +
  geom_density(color = "black", alpha = 0.7) +
  labs(x = "Comment Count", y = "Density") +
  theme_minimal(base_size = 12) +
  theme(panel.background = element_rect(fill = "white", color = NA),
        plot.background = element_rect(fill = "white", color = NA),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 45, hjust = 1))

# Display the plots separately
print(p1)
print(p2)
print(p3)