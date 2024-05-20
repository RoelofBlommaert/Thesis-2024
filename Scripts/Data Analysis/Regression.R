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
library(ggplot2)
library(broom)


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
describe(model_data)
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


# Summary of the model
summary(quadratic_model)

# Extract slopes of Irregularity of OA
coefficients <- summary(IR_quad_nb_model_views)$coefficients
beta_1 <- coefficients["Irregularity.of.Object.Arrangement", "Estimate"]
beta_2 <- coefficients["squared_Irregularity_of_OA", "Estimate"]

# Define the range of the independent variable
x_min <- min(norm_data$Irregularity.of.Object.Arrangement, na.rm = TRUE)
x_max <- max(norm_data$Irregularity.of.Object.Arrangement, na.rm = TRUE)

# Calculate the slopes at the minimum and maximum values of the independent variable
slope_min <- beta_1 + 2 * beta_2 * x_min
slope_max <- beta_1 + 2 * beta_2 * x_max

# Function to calculate standard error of the slope
calculate_slope_se <- function(x, model, beta_1, beta_2) {
  vcov_matrix <- vcov(model)
  se_slope <- sqrt(vcov_matrix["Irregularity.of.Object.Arrangement", "Irregularity.of.Object.Arrangement"] + 
                     (4 * x^2) * vcov_matrix["squared_Irregularity_of_OA", "squared_Irregularity_of_OA"] + 
                     (4 * x) * vcov_matrix["Irregularity.of.Object.Arrangement", "squared_Irregularity_of_OA"])
  return(se_slope)
}

# Calculate standard errors
se_slope_min <- calculate_slope_se(x_min, IR_quad_nb_model_views, beta_1, beta_2)
se_slope_max <- calculate_slope_se(x_max, IR_quad_nb_model_views, beta_1, beta_2)

# Calculate t-values and p-values for the slopes
t_slope_min <- slope_min / se_slope_min
t_slope_max <- slope_max / se_slope_max

p_slope_min <- 2 * pt(abs(t_slope_min), df = df.residual(IR_quad_nb_model_views), lower.tail = FALSE)
p_slope_max <- 2 * pt(abs(t_slope_max), df = df.residual(IR_quad_nb_model_views), lower.tail = FALSE)

# Print the slopes and their significance
cat("Slope at x_min (", x_min, "): ", slope_min, "p-value: ", p_slope_min, "\n")
cat("Slope at x_max (", x_max, "): ", slope_max, "p-value: ", p_slope_max, "\n")


# Extract slopes of Colour Complexity ~ Comments
coefficients <- summary(CC_quad_nb_model_comments)$coefficients
beta_1 <- coefficients["Color.Complexity", "Estimate"]
beta_2 <- coefficients["squared_Color_Complexity", "Estimate"]

# Define the range of the independent variable
x_min <- min(norm_data$Color.Complexity, na.rm = TRUE)
x_max <- max(norm_data$Color.Complexity, na.rm = TRUE)

# Calculate the slopes at the minimum and maximum values of the independent variable
slope_min <- beta_1 + 2 * beta_2 * x_min
slope_max <- beta_1 + 2 * beta_2 * x_max

# Function to calculate standard error of the slope
calculate_slope_se <- function(x, model, beta_1, beta_2) {
  vcov_matrix <- vcov(model)
  se_slope <- sqrt(vcov_matrix["Color.Complexity", "Color.Complexity"] + 
                     (4 * x^2) * vcov_matrix["squared_Color_Complexity", "squared_Color_Complexity"] + 
                     (4 * x) * vcov_matrix["Color.Complexity", "squared_Color_Complexity"])
  return(se_slope)
}

# Calculate standard errors
se_slope_min <- calculate_slope_se(x_min, CC_quad_nb_model_comments, beta_1, beta_2)
se_slope_max <- calculate_slope_se(x_max, CC_quad_nb_model_comments, beta_1, beta_2)

# Calculate t-values and p-values for the slopes
t_slope_min <- slope_min / se_slope_min
t_slope_max <- slope_max / se_slope_max

p_slope_min <- 2 * pt(abs(t_slope_min), df = df.residual(CC_quad_nb_model_comments), lower.tail = FALSE)
p_slope_max <- 2 * pt(abs(t_slope_max), df = df.residual(CC_quad_nb_model_comments), lower.tail = FALSE)

# Print the slopes and their significance
cat("Slope at x_min (", x_min, "): ", slope_min, "p-value: ", p_slope_min, "\n")
cat("Slope at x_max (", x_max, "): ", slope_max, "p-value: ", p_slope_max, "\n")



# Function to calculate the turning point and its 95% confidence interval
calculate_turning_point_ci <- function(model, iv, squared_iv) {
  # Extract coefficients
  coef_summary <- summary(model)$coefficients
  beta_1 <- coef_summary[iv, "Estimate"]
  beta_2 <- coef_summary[squared_iv, "Estimate"]
  
  # Calculate the turning point
  turning_point <- -beta_1 / (2 * beta_2)
  
  # Calculate the standard error and confidence interval using deltaMethod
  delta_expr <- paste0("-(", iv, ") / (2 * ", squared_iv, ")")
  delta_result <- deltaMethod(model, delta_expr)
  
  # Extract the confidence interval from delta_result
  ci_lower <- delta_result$`2.5 %`
  ci_upper <- delta_result$`97.5 %`
  
  # Return the results
  list(turning_point = turning_point, ci_lower = ci_lower, ci_upper = ci_upper)
}

# Define the list of models with named elements
models <- list(
  CC_quad_nb_model_views = CC_quad_nb_model_views,
  CC_quad_nb_model_likes = CC_quad_nb_model_likes,
  CC_quad_nb_model_comments = CC_quad_nb_model_comments,
  ED_quad_nb_model_views = ED_quad_nb_model_views,
  ED_quad_nb_model_likes = ED_quad_nb_model_likes,
  ED_quad_nb_model_comments = ED_quad_nb_model_comments,
  LE_quad_nb_model_views = LE_quad_nb_model_views,
  LE_quad_nb_model_likes = LE_quad_nb_model_likes,
  LE_quad_nb_model_comments = LE_quad_nb_model_comments,
  IR_quad_nb_model_views = IR_quad_nb_model_views,
  IR_quad_nb_model_likes = IR_quad_nb_model_likes,
  IR_quad_nb_model_comments = IR_quad_nb_model_comments,
  UO_quad_nb_model_views = UO_quad_nb_model_views,
  UO_quad_nb_model_likes = UO_quad_nb_model_likes,
  UO_quad_nb_model_comments = UO_quad_nb_model_comments,
  VV_quad_nb_model_views = VV_quad_nb_model_views,
  VV_quad_nb_model_likes = VV_quad_nb_model_likes,
  VV_quad_nb_model_comments = VV_quad_nb_model_comments
)

# Define the list of independent variables and their squared counterparts
ivs <- c("Color.Complexity", "Edge.Density", "Luminance.Complexity", "Irregularity.of.Object.Arrangement", "Unique.Objects.Count", "Visual.Variety")
squared_ivs <- c("squared_Color_Complexity", "squared_Edge_Density", "squared_Luminance_Complexity", "squared_Irregularity_of_OA", "squared_Unique_Objects_Count", "squared_Visual_Variety")


# Function to apply the calculation to all models
apply_calculations <- function(models, ivs, squared_ivs) {
  results <- list()
  
  for (i in seq_along(ivs)) {
    iv <- ivs[i]
    squared_iv <- squared_ivs[i]
    
    for (model_name in names(models)) {
      model <- models[[model_name]]
      
      # Debug print to check the coefficients
      print(paste("Model:", model_name))
      print(paste("IV:", iv))
      print(paste("Squared IV:", squared_iv))
      print(names(coef(model)))
      
      if (iv %in% names(coef(model)) && squared_iv %in% names(coef(model))) {
        result <- calculate_turning_point_ci(model, iv, squared_iv)
        results[[paste(model_name, iv, sep = "_")]] <- result
      }
    }
  }
  
  return(results)
}

# Apply the function to all models and independent variables
results <- apply_calculations(models, ivs, squared_ivs)

# Print the results
results





# Function to apply min-max normalization
min_max_normalize <- function(x) {
  return((x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE)))
}

# Create a new data frame for min-max normalization
mm_data <- data

# Define the variable names for independent and control variables
iv_list <- c("Color.Complexity", "Edge.Density", "Luminance.Complexity", "Irregularity.of.Object.Arrangement", "Unique.Objects.Count", "Visual.Variety")
control_vars <- c("logSubscribers", "Time", "Length", "subscriberCount")

# Apply min-max normalization to each independent and control variable
for (iv in iv_list) {
  mm_data[[iv]] <- min_max_normalize(mm_data[[iv]])
  mm_data[[paste0("squared_", iv)]] <- mm_data[[iv]]^2
}

for (control in control_vars) {
  if (control %in% names(mm_data)) {
    mm_data[[control]] <- min_max_normalize(mm_data[[control]])
  }
}

# Re-fit NB models with min-max normalized data
CC_quad_nb_model_views <- glm.nb(viewCount ~ Color.Complexity + squared_Color.Complexity + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))
CC_quad_nb_model_likes <- glm.nb(likeCount ~ Color.Complexity + squared_Color.Complexity + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))
CC_quad_nb_model_comments <- glm.nb(commentCount ~ Color.Complexity + squared_Color.Complexity + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))

ED_quad_nb_model_views <- glm.nb(viewCount ~ Edge.Density + squared_Edge.Density + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))
ED_quad_nb_model_likes <- glm.nb(likeCount ~ Edge.Density + squared_Edge.Density + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))
ED_quad_nb_model_comments <- glm.nb(commentCount ~ Edge.Density + squared_Edge.Density + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))

LE_quad_nb_model_views <- glm.nb(viewCount ~ Luminance.Complexity + squared_Luminance.Complexity + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))
LE_quad_nb_model_likes <- glm.nb(likeCount ~ Luminance.Complexity + squared_Luminance.Complexity + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))
LE_quad_nb_model_comments <- glm.nb(commentCount ~ Luminance.Complexity + squared_Luminance.Complexity + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))

IR_quad_nb_model_views <- glm.nb(viewCount ~ Irregularity.of.Object.Arrangement + squared_Irregularity.of.Object.Arrangement + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))
IR_quad_nb_model_likes <- glm.nb(likeCount ~ Irregularity.of.Object.Arrangement + squared_Irregularity.of.Object.Arrangement + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))
IR_quad_nb_model_comments <- glm.nb(commentCount ~ Irregularity.of.Object.Arrangement + squared_Irregularity.of.Object.Arrangement + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))

UO_quad_nb_model_views <- glm.nb(viewCount ~ Unique.Objects.Count + squared_Unique.Objects.Count + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))
UO_quad_nb_model_likes <- glm.nb(likeCount ~ Unique.Objects.Count + squared_Unique.Objects.Count + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))
UO_quad_nb_model_comments <- glm.nb(commentCount ~ Unique.Objects.Count + squared_Unique.Objects.Count + subscriberCount + Time + Length + status, data = mm_data, control = glm.control(maxit = 100))

# Function to create scatter plots with quadratic smoothers and percentile marks
plot_quad_relationship <- function(data, iv, dv, title) {
  # Calculate the 25th, 50th, and 75th percentiles for the independent variable
  percentiles <- quantile(data[[iv]], probs = c(0.01, 0.25, 0.50, 0.75, 0.99), na.rm = TRUE)
  
  # Calculate the y-values on the smooth line at the percentile positions
  gg <- ggplot(data, aes_string(x = iv, y = dv)) +
    geom_smooth(method = "lm", formula = y ~ poly(x, 2), color = "black", se = FALSE)
  smooth_data <- ggplot_build(gg)$data[[1]]
  
  # Find the y values at the percentiles
  y_values <- sapply(percentiles, function(p) {
    smooth_data$y[which.min(abs(smooth_data$x - p))]
  })
  
  gg + geom_point(aes(x = percentiles[1], y = y_values[1]), color = "black", size = 2, shape = 21, fill = "white") +
    geom_point(aes(x = percentiles[2], y = y_values[2]), color = "black", size = 2, shape = 21, fill = "white") +
    geom_point(aes(x = percentiles[3], y = y_values[3]), color = "black", size = 2, shape = 21, fill = "white") +
    geom_point(aes(x = percentiles[4], y = y_values[4]), color = "black", size = 2, shape = 21, fill = "white") +
    geom_point(aes(x = percentiles[5], y = y_values[5]), color = "black", size = 2, shape = 21, fill = "white") +
    labs(title = title) +
    theme_minimal() +
    theme(axis.text.y = element_blank(), axis.title = element_blank(), panel.grid = element_blank(), axis.line = element_line(color = "black"))
}

# Define the dependent variables
dv_list <- c("viewCount", "likeCount", "commentCount")

# Create plots for each combination of independent and dependent variables
for (iv in iv_list) {
  for (dv in dv_list) {
    # Create a title for the plot
    title <- paste(dv, "vs", iv, "(Quadratic)")
    
    # Generate and display the plot
    print(plot_quad_relationship(mm_data, iv, dv, title))
  }
}




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

