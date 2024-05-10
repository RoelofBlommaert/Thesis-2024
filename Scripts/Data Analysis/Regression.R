# Load necessary libraries
library(MASS)
library(dplyr)
library(Hmisc)
# Install and load the car package if not already installed
if (!require(car)) {
  install.packages("car")
  library(car)
}
library(pscl)


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
views_formula <- 'Views ~ Color.Complexity + Edge.Density + Luminance.Complexity + Asymmetry.of.Object.Arrangement +
Irregularity.of.Object.Arrangement + Unique.Objects.Count + Visual.Variety + logSubscribers + Time + Length + status'

likes_formula <- 'Likes ~ Color.Complexity + Edge.Density + Luminance.Complexity + Asymmetry.of.Object.Arrangement +
Irregularity.of.Object.Arrangement + Unique.Objects.Count + Visual.Variety + logSubscribers + Time + Length + status'

comments_formula <- 'Comments ~ Color.Complexity + Edge.Density + Luminance.Complexity + Asymmetry.of.Object.Arrangement +
Irregularity.of.Object.Arrangement + Unique.Objects.Count + Visual.Variety + logSubscribers + Time + Length + status'

# Fit Poisson Model for Views as a baseline
poisson_model_views <- glm(views_formula, family = poisson, data = model_data)
poisson_model_likes <- glm(likes_formula, family = poisson, data = model_data)
poisson_model_comments <- glm(comments_formula, family = poisson, data = model_data)
summary(poisson_model_views)
summary(poisson_model_likes)
summary(poisson_model_comments)

# Fit Negative Binomial Model for linear functions
nb_model_views <- glm.nb(views_formula, data = model_data, control = glm.control(maxit = 100))
nb_model_likes <- glm.nb(likes_formula, data = model_data, control = glm.control(maxit = 100))
nb_model_comments <- glm.nb(comments_formula, data = model_data, control = glm.control(maxit = 100))
summary(nb_model_views)
summary(nb_model_likes)
summary(nb_model_comments)



# Calculate VIF for each of the models to check for multicollinearity
vif_model_views <- vif(nb_model_views)
vif_model_likes <- vif(poisson_model_likes)
print(vif_model_views)
print(vif_model_likes)


# Normalizing all variables in a new dataframe 'norm_data'

norm_data <- data %>%
  mutate(
    # Normalize only independent variables
    Luminance.Complexity = scale(Luminance.Complexity),
    Color.Complexity = scale(Color.Complexity),
    Edge.Density = scale(Edge.Density),
    Asymmetry.of.Object.Arrangement = scale(Asymmetry.of.Object.Arrangement),
    Irregularity.of.Object.Arrangement = scale(Irregularity.of.Object.Arrangement),
    Unique.Objects.Count = scale(Unique.Objects.Count),
    Visual.Variety = scale(Visual.Variety),
    Time = scale(Time),
    Length = scale(Length),
    subscriberCount = scale(subscriberCount),  # Normalizing after taking log
    # Ensure DVs are not scaled
    Views = viewCount,  # DV kept in original scale
    Likes = likeCount,  # DV kept in original scale
    Comments = commentCount,  # DV kept in original scale
    status = ifelse(status == 'public', 1, 0)
  )

norm_data <- norm_data %>%
  mutate(
    squared_Luminance_Complexity = Luminance.Complexity^2,
    squared_Color_Complexity = Color.Complexity^2,
    squared_Edge_Density = Edge.Density^2,
    squared_Asymmetry_of_OA = Asymmetry.of.Object.Arrangement^2,
    squared_Irregularity_of_OA = Irregularity.of.Object.Arrangement^2,
    squared_Unique_Objects_Count = Unique.Objects.Count^2,
    squared_Visual_Variety = Visual.Variety^2,
    logSubscribers = log(subscriberCount +1)
  )

#Make formulas for regression
views_formula <- 'Views ~ Color.Complexity + Edge.Density + Luminance.Complexity + Asymmetry.of.Object.Arrangement +
Irregularity.of.Object.Arrangement + Unique.Objects.Count + Visual.Variety + subscriberCount + Time + Length + status'

likes_formula <- 'Likes ~ Color.Complexity + Edge.Density + Luminance.Complexity + Asymmetry.of.Object.Arrangement +
Irregularity.of.Object.Arrangement + Unique.Objects.Count + Visual.Variety + subscriberCount + Time + Length + status'

comments_formula <- 'Comments ~ Color.Complexity + Edge.Density + Luminance.Complexity + Asymmetry.of.Object.Arrangement +
Irregularity.of.Object.Arrangement + Unique.Objects.Count + Visual.Variety + subscriberCount + Time + Length + status'

# Fit Poisson Model for Views as a baseline
poisson_model_views <- glm(views_formula, family = poisson, data = norm_data)
poisson_model_likes <- glm(likes_formula, family = poisson, data = norm_data)
poisson_model_comments <- glm(comments_formula, family = poisson, data = norm_data)
summary(poisson_model_views)
summary(poisson_model_likes)
summary(poisson_model_comments)

# Fit Negative Binomial Model for linear functions
nb_model_views <- glm.nb(views_formula, data = norm_data, control = glm.control(maxit = 100))
nb_model_likes <- glm.nb(likes_formula, data = norm_data, control = glm.control(maxit = 100))
nb_model_comments <- glm.nb(comments_formula, data = norm_data, control = glm.control(maxit = 100))
summary(nb_model_views)
summary(nb_model_likes)
summary(nb_model_comments)

#Perform LRT
pchisq(2 * (logLik(nb_model_likes) - logLik(poisson_model_likes)), df = 1, lower.tail = FALSE)

log_likelihood <- logLik(nb_model_comments)
bic_value <- BIC(nb_model_comments)
nagelkerke_r2 <- pR2(nb_model_comments)
print(nagelkerke_r2)
print(bic_value)
print(log_likelihood)


#Conducting PCA to deal with multicoll
pca_results <- prcomp(norm_data[, c("Asymmetry.of.Object.Arrangement", "Irregularity.of.Object.Arrangement")], center = TRUE, scale. = TRUE)

# Extracting the first principal component
norm_data$PCA1 <- pca_results$x[, 1]

# Optional: View summary of PCA to see variance explained
print(summary(pca_results))
print(pca_results$rotation)

norm_data$squared_PCA1 <- norm_data$PCA1^2


#Make formulas for regression
pca_views_formula <- 'Views ~ Color.Complexity + Edge.Density + Luminance.Complexity + PCA1 + Unique.Objects.Count + Visual.Variety + logSubscribers + Time + Length + status'
pca_likes_formula <- 'Likes ~ Color.Complexity + Edge.Density + Luminance.Complexity + PCA1 + Unique.Objects.Count + Visual.Variety + logSubscribers + Time + Length + status'
pca_comment_formula <- 'Comments ~ Color.Complexity + Edge.Density + Luminance.Complexity + PCA1 + Unique.Objects.Count + Visual.Variety + logSubscribers + Time + Length + status'

# Fit Negative Binomial Model for linear functions with PCA
nb_model_views <- glm.nb(pca_views_formula, data = norm_data, control = glm.control(maxit = 100))
nb_model_likes <- glm.nb(pca_likes_formula, data = norm_data, control = glm.control(maxit = 100))
nb_model_comments <- glm.nb(pca_comment_formula, data = norm_data, control = glm.control(maxit = 100))
summary(nb_model_views)
summary(nb_model_likes)
summary(nb_model_comments)

log_likelihood <- logLik(nb_model_views)
bic_value <- BIC(nb_model_views)
nagelkerke_r2 <- pR2(nb_model_views)
print(nagelkerke_r2)
print(bic_value)
print(log_likelihood)

#Checking for quadratic relationships
control_settings <- glm.control(maxit = 200, epsilon = 1e-08, trace = TRUE)  # More conservative settings

# Fit NB Model for linear and quadratic of Colour Complexity
CC_nb_model_views <- glm.nb('Views ~ Color.Complexity + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
CC_quad_nb_model_views <- glm.nb('Views ~ Color.Complexity + squared_Color_Complexity + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
CC_nb_model_likes <- glm.nb('Likes ~ Color.Complexity + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
CC_quad_nb_model_likes <- glm.nb('Likes ~ Color.Complexity + squared_Color_Complexity + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
CC_nb_model_comments <- glm.nb('Comments ~ Color.Complexity + subscriberCount + Time + Length + status', norm_data, control = glm.control(maxit = 100))
CC_quad_nb_model_comments <- glm.nb('Comments ~ Color.Complexity + squared_Color_Complexity + subscriberCount + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
summary(CC_nb_model_views)
summary(CC_quad_nb_model_views)
summary(CC_nb_model_likes)
summary(CC_quad_nb_model_likes)
summary(CC_nb_model_comments)
summary(CC_quad_nb_model_comments)
#Quick VIF check
vif_quad_model_views <- vif(CC_quad_nb_model_views)
print(vif_quad_model_views)

# Fit NB Model for linear and quadratic of Edge Density
ED_nb_model_views <- glm.nb('Views ~ Edge.Density + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
ED_quad_nb_model_views <- glm.nb('Views ~ Edge.Density + squared_Edge_Density + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
ED_nb_model_likes <- glm.nb('Likes ~ Edge.Density + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
ED_quad_nb_model_likes <- glm.nb('Likes ~ Edge.Density + squared_Edge_Density + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
ED_nb_model_comments <- glm.nb('Comments ~ Edge.Density + subscriberCount + Time + Length + status', norm_data, control = glm.control(maxit = 100))
ED_quad_nb_model_comments <- glm.nb('Comments ~ Edge.Density + squared_Edge_Density + subscriberCount + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
summary(ED_nb_model_views)
summary(ED_quad_nb_model_views)
summary(ED_nb_model_likes)
summary(ED_quad_nb_model_likes)
summary(ED_nb_model_comments)
summary(ED_quad_nb_model_comments)

# Fit NB Model for linear and quadratic of Lum Entropy
LE_nb_model_views <- glm.nb('Views ~ Luminance.Complexity + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
LE_quad_nb_model_views <- glm.nb('Views ~ Luminance.Complexity + squared_Luminance_Complexity + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
LE_nb_model_likes <- glm.nb('Likes ~ Luminance.Complexity + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
LE_quad_nb_model_likes <- glm.nb('Likes ~ Luminance.Complexity + squared_Luminance_Complexity + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
LE_nb_model_comments <- glm.nb('Comments ~ Luminance.Complexity + subscriberCount + Time + Length + status', norm_data, control = glm.control(maxit = 100))
LE_quad_nb_model_comments <- glm.nb('Comments ~ Luminance.Complexity + squared_Luminance_Complexity + subscriberCount + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
summary(LE_nb_model_views)
summary(LE_quad_nb_model_views)
summary(LE_nb_model_likes)
summary(LE_quad_nb_model_likes)
summary(LE_nb_model_comments)
summary(LE_quad_nb_model_comments)

# Fit NB Model for linear and quadratic of Irregularity of OA
IR_nb_model_views <- glm.nb('Views ~ Irregularity.of.Object.Arrangement + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
IR_quad_nb_model_views <- glm.nb('Views ~ Irregularity.of.Object.Arrangement + squared_Irregularity_of_OA + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
IR_nb_model_likes <- glm.nb('Likes ~ Irregularity.of.Object.Arrangement + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
IR_quad_nb_model_likes <- glm.nb('Likes ~ Irregularity.of.Object.Arrangement + squared_Irregularity_of_OA + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
IR_nb_model_comments <- glm.nb('Comments ~ Irregularity.of.Object.Arrangement + subscriberCount + Time + Length + status', norm_data, control = glm.control(maxit = 100))
IR_quad_nb_model_comments <- glm.nb('Comments ~ Irregularity.of.Object.Arrangement + squared_Irregularity_of_OA + subscriberCount + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
summary(IR_nb_model_views)
summary(IR_quad_nb_model_views)
summary(IR_nb_model_likes)
summary(IR_quad_nb_model_likes)
summary(IR_nb_model_comments)
summary(IR_quad_nb_model_comments)

# Fit NB Model for linear and quadratic of Unique Objects
UO_nb_model_views <- glm.nb('Views ~ Unique.Objects.Count + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
UO_quad_nb_model_views <- glm.nb('Views ~ Unique.Objects.Count + squared_Unique_Objects_Count + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
UO_nb_model_likes <- glm.nb('Likes ~ Unique.Objects.Count + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
UO_quad_nb_model_likes <- glm.nb('Likes ~ Unique.Objects.Count + squared_Unique_Objects_Count + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
UO_nb_model_comments <- glm.nb('Comments ~ Unique.Objects.Count + subscriberCount + Time + Length + status', norm_data, control = glm.control(maxit = 100))
UO_quad_nb_model_comments <- glm.nb('Comments ~ Unique.Objects.Count + squared_Unique_Objects_Count + subscriberCount + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
summary(UO_nb_model_views)
summary(UO_quad_nb_model_views)
summary(UO_nb_model_likes)
summary(UO_quad_nb_model_likes)
summary(UO_nb_model_comments)
summary(UO_quad_nb_model_comments)

# Fit NB Model for Visual Variety
VV_nb_model_views <- glm.nb('Views ~ Visual.Variety + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
VV_quad_nb_model_views <- glm.nb('Views ~ Visual.Variety + squared_Visual_Variety + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
VV_nb_model_likes <- glm.nb('Likes ~ Visual.Variety + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
VV_quad_nb_model_likes <- glm.nb('Likes ~ Visual.Variety + squared_Visual_Variety + logSubscribers + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
VV_nb_model_comments <- glm.nb('Comments ~ Visual.Variety + subscriberCount + Time + Length + status', norm_data, control = glm.control(maxit = 100))
VV_quad_nb_model_comments <- glm.nb('Comments ~ Visual.Variety + squared_Visual_Variety + subscriberCount + Time + Length + status', data = norm_data, control = glm.control(maxit = 100))
summary(VV_nb_model_views)
summary(VV_quad_nb_model_views)
summary(VV_nb_model_likes)
summary(VV_quad_nb_model_likes)
summary(VV_nb_model_comments)
summary(VV_quad_nb_model_comments)

lrt_result <- anova(VV_nb_model_comments, nb_model_comments, test = "Chisq")
print(lrt_result)
max_value <- min(norm_data$Irregularity.of.Object.Arrangement, na.rm = TRUE)
print(max_value)
# Select only the continuous variables you're interested in
model_data['Subscribers'] <- exp(model_data['logSubscribers'])
data_for_correlation <- model_data[, c("Views", "Likes", "Comments", "Luminance.Complexity", "Color.Complexity", "Edge.Density","Asymmetry.of.Object.Arrangement" ,"Irregularity.of.Object.Arrangement", "Unique.Objects.Count", "Visual.Variety", "Subscribers", "Time", "Length", "status")]

# Calculate correlation matrix and corresponding p-values
cor_results <- rcorr(as.matrix(data_for_correlation))

# Extract correlations and p-values
cor_matrix <- cor_results$r  # Correlation coefficients
p_matrix <- cor_results$P  # P-values

# Function to apply significance levels
format_significance <- function(cor, p) {
  significance_level <- ifelse(p < 0.001, "***", ifelse(p < 0.01, "**", ifelse(p < 0.05, "*", "")))
  paste0(sprintf("%.2f", cor), significance_level)
}

# Apply significance formatting to the correlation matrix
cor_matrix_formatted <- mapply(format_significance, cor_matrix, p_matrix)
cor_matrix_formatted <- matrix(cor_matrix_formatted, nrow = dim(cor_matrix)[1], byrow = TRUE)
dimnames(cor_matrix_formatted) <- list(colnames(data_for_correlation), colnames(data_for_correlation))

# Clear the upper triangle of the matrix
cor_matrix_formatted[upper.tri(cor_matrix_formatted)] <- ""

# Print the formatted correlation matrix
print(cor_matrix_formatted)

# Optional: View in a more readable format if in RStudio and interactive session
if(interactive()) View(cor_matrix_formatted)

# Save your correlation matrix to a CSV file
write.csv(cor_matrix_formatted, "Data/correlation_matrix.csv", row.names = TRUE)

