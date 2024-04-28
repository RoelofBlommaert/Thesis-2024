import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.api as sm
from statsmodels.formula.api import glm
from statsmodels.stats.outliers_influence import variance_inflation_factor
from statsmodels.tools.tools import add_constant


data = pd.read_csv('Data/feature_matrix.csv')

# Assume 'X' is your dataframe containing the independent variables
data['squared Luminance Complexity'] = data['Luminance Complexity']**2
data['squared Color Complexity'] = data['Color Complexity']**2
data['squared Edge Density'] = data['Edge Density']**2
data['squared Asymmetry of Object Arrangement'] = data['Asymmetry of Object Arrangement']**2
data['squared Irregularity of Object Arrangement'] = data['Irregularity of Object Arrangement']**2
data['squared Visual Variety'] = data['Visual Variety']**2
data['squared Unique Objects Count'] = data['Unique Objects Count']**2
print(data)


X = data[['Luminance Complexity', 'Color Complexity', 'Edge Density', 'Asymmetry of Object Arrangement', 'Irregularity of Object Arrangement', 'Unique Objects Count',
           'Visual Variety']]  
X = add_constant(X)  # add a constant term for the intercept

# Calculate VIF for each explanatory variable
vif = pd.DataFrame()
vif["variables"] = X.columns
vif["VIF"] = [variance_inflation_factor(X.values, i) for i in range(X.shape[1])]
print(vif)

Y = data[['squared Luminance Complexity', 'squared Color Complexity', 'squared Edge Density', 'squared Asymmetry of Object Arrangement', 
          'squared Irregularity of Object Arrangement', 'squared Unique Objects Count',
           'squared Visual Variety']]  
Y = add_constant(Y)  # add a constant term for the intercept

# Calculate VIF for each explanatory variable
vif = pd.DataFrame()
vif["variables"] = Y.columns
vif["VIF"] = [variance_inflation_factor(Y.values, i) for i in range(X.shape[1])]
print(vif)

#Make subset of data
model_data = data[['squared Luminance Complexity', 'squared Color Complexity', 'squared Edge Density', 'squared Asymmetry of Object Arrangement', 
          'squared Irregularity of Object Arrangement', 'squared Unique Objects Count',
           'squared Visual Variety', 'Luminance Complexity', 'Color Complexity', 'Edge Density', 'Asymmetry of Object Arrangement', 'Irregularity of Object Arrangement', 'Unique Objects Count',
           'Visual Variety', 'Time', 'Length']].copy()
model_data['Views'] = data['viewCount']
model_data['Likes'] = data['likeCount']
model_data['Comments'] = data['commentCount']
model_data['logSubscribers'] = np.log(data['subscriberCount'])
model_data['status'] = np.where(data['status'] == 'public', 1, 0)
model_data.columns = [col.replace(' ', '_') for col in model_data.columns]

print(model_data)

#Make formulas for regression
lin_views_formula = '''Views ~ Color_Complexity + Edge_Density + Luminance_Complexity + 
Irregularity_of_Object_Arrangement + Unique_Objects_Count + Visual_Variety + logSubscribers + Time + Length + status'''

quad_views_formula = '''Views ~ squared_Color_Complexity + squared_Edge_Density + squared_Luminance_Complexity + 
squared_Irregularity_of_Object_Arrangement + squared_Unique_Objects_Count + squared_Visual_Variety + logSubscribers + Time + Length + status'''

lin_likes_formula = '''Likes ~ Color_Complexity + Edge_Density + Luminance_Complexity + Asymmetry_of_Object_Arrangement + 
Irregularity_of_Object_Arrangement + Unique_Objects_Count + Visual_Variety + logSubscribers + Time + Length + status'''

quad_likes_formula = '''Likes ~ squared_Color_Complexity + squared_Edge_Density + squared_Luminance_Complexity + squared_Asymmetry_of_Object_Arrangement + 
squared_Irregularity_of_Object_Arrangement + squared_Unique_Objects_Count + squared_Visual_Variety + logSubscribers + Time + Length + status'''

lin_comment_formula = '''Comments ~ Color_Complexity + Edge_Density + Luminance_Complexity + Asymmetry_of_Object_Arrangement + 
Irregularity_of_Object_Arrangement + Unique_Objects_Count + Visual_Variety + logSubscribers + Time + Length + status'''

quad_comment_formula = '''Comments ~ squared_Color_Complexity + squared_Edge_Density + squared_Luminance_Complexity + squared_Asymmetry_of_Object_Arrangement + 
squared_Irregularity_of_Object_Arrangement + squared_Unique_Objects_Count + squared_Visual_Variety + logSubscribers + Time + Length + status'''

# Fitting a Poisson & Negative Binomial Model 

po_lin_view_model = glm(formula=lin_views_formula, data=model_data, family=sm.families.Poisson()).fit()
print(po_lin_view_model.summary())
nb_lin_view_model = glm(formula=lin_views_formula, data=model_data, family=sm.families.NegativeBinomial()).fit()
print(nb_lin_view_model.summary())

print(f"Poisson AIC: {po_lin_view_model.aic}")
print(f"Negative Binomial AIC: {nb_lin_view_model.aic}")

nb_quad_view_model = glm(formula=quad_views_formula, data=model_data, family=sm.families.NegativeBinomial()).fit()
print(nb_quad_view_model.summary())

nb_lin_like_model = glm(formula=lin_likes_formula, data=model_data, family=sm.families.NegativeBinomial()).fit()
print(nb_lin_like_model.summary())

nb_quad_like_model = glm(formula=quad_likes_formula, data=model_data, family=sm.families.NegativeBinomial()).fit()
print(nb_quad_like_model.summary())

nb_lin_comment_model = glm(formula=lin_comment_formula, data=model_data, family=sm.families.NegativeBinomial()).fit()
print(nb_lin_comment_model.summary())

po_lin_comment_model = glm(formula=lin_comment_formula, data=model_data, family=sm.families.Poisson()).fit()
print(po_lin_view_model.summary())

print(f"Poisson AIC: {po_lin_comment_model.aic}")
print(f"Negative Binomial AIC: {nb_lin_comment_model.aic}")

nb_quad_comment_model = glm(formula=quad_comment_formula, data=model_data, family=sm.families.NegativeBinomial()).fit()
print(nb_quad_comment_model.summary())

# Residuals plot
residuals = model.resid_response
sns.histplot(residuals, kde=True)
plt.title('Residuals of the Model')
plt.show()

# Check for patterns or anomalies
sns.scatterplot(x=np.arange(len(residuals)), y=residuals)
plt.title('Residuals Distribution')
plt.show()