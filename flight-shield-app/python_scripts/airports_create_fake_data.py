import pandas as pd
import csv

if __name__ == "__main__":
    df = pd.read_csv("~/Downloads/airlines(1).csv")


    for i in range(15, 1001):
        df2 = {"IATA_CODE": i, "AIRLINE": "NA"}
        df = df._append(df2, ignore_index = True)
    
    df.to_csv("modified_airlines.csv", sep=',')

    print(df)
    