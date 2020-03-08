# Loading libraries
import os
import pdb
import pandas as pd
import sqlalchemy
from tqdm import tqdm

# Defining projects paths
THIS_FILE = os.path.abspath(__file__)
WORK_DIR  = os.path.dirname(os.path.dirname(THIS_FILE))
DATA_DIR  = os.path.join(WORK_DIR, '00_data')
SQL_DIR   = os.path.dirname(THIS_FILE)

# Ingestão dos dados no banco SQL
string_connection = 'sqlite:///{path}'.format(path=os.path.join(SQL_DIR, 'bikes.db'))
connection = sqlalchemy.create_engine(string_connection)

data_names = [name for name in os.listdir(os.path.join(DATA_DIR,'bike_sales','data_raw')) if name.endswith(".xlsx")]
for data_name in tqdm(data_names):
    df = pd.read_excel(os.path.join(DATA_DIR, 'bike_sales', 'data_raw', data_name))
    df.columns = [col.replace('.', '_') for col in df.columns]
    data_name = data_name.replace('.xlsx', '')
    df.to_sql(data_name, connection)    
