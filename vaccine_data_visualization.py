import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import csv

def read_from_csv(filename):
    vaccine_df = pd.read_csv(filename)
    daily_vacc_df = vaccine_df.loc[df["metric"] == "Daily" and df["type"] == "All COVID Vaccines"]
    print(daily_vacc_df)
