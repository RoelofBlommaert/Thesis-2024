# Load necessary libraries
library(MASS)
library(dplyr)

setwd("/Users/roelofblommaert/Thesis-2024/Thesis-2024")
# Assuming your data is read from a CSV or similar
data <- read.csv("Data/feature_matrix.csv")

# Create squared and interaction terms, and transform data as needed
model_data <- data %>%
  mutate(
    squared_Luminance_Complexity = `Luminance.Complexity`^2,
    squared_Color_Complexity = `Color.Complexity`^2,
    squared_Edge_Density = `Edge.Density`^2,
    squared_Asymmetry_of_OA = `Asymmetry.of.Object.Arrangement`^2,
    squared_Irregularity_of_OA = `Irregularity.of.Object.Arrangement`^2,
    squared_Unique_Objects_Count = `Unique.Objects.Count`^2,
    squared_Visual_Variety = `Visual.Variety`^2,
    Views = viewCount,
    Likes = likeCount,
    Comments = commentCount,
    logSubscribers = log(subscriberCount),
    status = ifelse(status == 'public', 1, 0)
  ) %>%
  select(starts_with("squared_"), `Luminance.Complexity`, `Color.Complexity`, `Edge.Density`,
         `Asymmetry.of.Object.Arrangement`, `Irregularity.of.Object.Arrangement`, `Unique.Objects.Count`,
         `Visual.Variety`, Time, Length, Views, Likes, Comments, logSubscribers, status)

# Print the data to check it
print(head(model_data))




#Make formulas for regression
lin_views_formula <- 'Views ~ Color.Complexity + Edge.Density + Luminance.Complexity + Asymmetry.of.Object.Arrangement +
Irregularity.of.Object.Arrangement + Unique.Objects.Count + Visual.Variety + logSubscribers + Time + Length + status'

quad_views_formula <- 'Views ~ squared_Color_Complexity + squared_Edge_Density + squared_Luminance_Complexity +
squared_Irregularity_of_OA + squared_Unique_Objects_Count + squared_Visual_Variety + logSubscribers + Time + Length + status'

lin_likes_formula <- 'Likes ~ Color.Complexity + Edge.Density + Luminance.Complexity + 
Irregularity.of.Object.Arrangement + Unique.Objects.Count + Visual.Variety + logSubscribers + Time + Length + status'

quad_likes_formula <- 'Likes ~ squared_Color_Complexity + squared_Edge_Density + squared_Luminance_Complexity + squared_Asymmetry_of_OA + 
squared_Irregularity_of_OA + squared_Unique_Objects_Count + squared_Visual_Variety + logSubscribers + Time + Length + status'

lin_comment_formula <- 'Comments ~ Color.Complexity + Edge.Density + Luminance.Complexity +
Irregularity.of.Object.Arrangement + Unique.Objects.Count + Visual.Variety + logSubscribers + Time + Length + status'

quad_comment_formula <- 'Comments ~ squared_Color_Complexity + squared_Edge_Density + squared_Luminance_Complexity + squared_Asymmetry_of_OA + 
squared_Irregularity_of_OA + squared_Unique_Objects_Count + squared_Visual_Variety + logSubscribers + Time + Length + status'

# Fit Poisson Model for Views as a baseline
poisson_model_views <- glm(lin_views_formula, family = poisson, data = model_data)
summary(poisson_model_views)

# Fit Negative Binomial Model for linear functions
nb_model_views <- glm.nb(lin_views_formula, data = model_data, control = glm.control(maxit = 100))
summary(nb_model_views)
nb_model_likes <- glm.nb(lin_likes_formula, data = model_data, control = glm.control(maxit = 50))
summary(nb_model_likes)
nb_model_comments <- glm.nb(lin_comment_formula, data = model_data, control = glm.control(maxit = 100))
summary(nb_model_comments)

# Example for quadratic model (adjust accordingly for Likes and Comments)
nb_model_views_quad <- glm.nb(quad_views_formula, data = model_data, control = glm.control(maxit = 100))
summary(nb_model_views_quad)
nb_model_likes_quad <- glm.nb(quad_likes_formula, data = model_data, control = glm.control(maxit = 100))
summary(nb_model_likes_quad)
control_settings <- glm.control(maxit = 50, epsilon = 1e-08, trace = TRUE)  # More conservative settings
nb_model_comments_quad <- glm.nb(quad_comment_formula, data = model_data, control = control_settings)
nb_model_comments_quad <- glm.nb(quad_comment_formula, data = model_data, control = glm.control(maxit = 100))
summary(nb_model_comments_quad)

