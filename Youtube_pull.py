from googleapiclient.discovery import build
import pandas as pd 
import seaborn as sns

path = 'Superbowl video link document.xlsx'
data = pd.read_excel(path, header=1, sheet_name=None)

print(data)

