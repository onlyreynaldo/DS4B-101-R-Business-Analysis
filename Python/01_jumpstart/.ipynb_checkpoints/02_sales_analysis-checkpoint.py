#%% Loading Libraries
import numpy as np
import pandas as pd
import os
import matplotlib.pyplot as plt


#%% Loading the data
THIS_FILE_PATH = os.path.abspath(__file__)
WORK_DIR = os.path.dirname(os.path.dirname(os.path.dirname(THIS_FILE_PATH)))
DATA_DIR = os.path.join(WORK_DIR, "00_data")

bikes_df = pd.read_excel(os.path.join(DATA_DIR, "bike_sales/data_raw/bikes.xlsx"))

orderlines_df = pd.read_excel(os.path.join(DATA_DIR, "bike_sales/data_raw/orderlines.xlsx"))


#%% 
view = (
    bikes_df["model"]
    .value_counts()
)


# %%
