import csv
import pandas as pd

if __name__ == "__main__":
    df = pd.read_csv("~/Downloads/delays.csv")

    # print(df)

    nan_count = df.isna().sum()
    print(nan_count)

    df['DEPARTURE_TIME'] = df['DEPARTURE_TIME'].fillna(0)
    df['DEPARTURE_DELAY'] = df['DEPARTURE_DELAY'].fillna(0)
    df['SCHEDULED_TIME'] = df['SCHEDULED_TIME'].fillna(0)
    df['ELAPSED_TIME'] = df['ELAPSED_TIME'].fillna(0)
    df['AIR_TIME'] = df['AIR_TIME'].fillna(0)
    df['ARRIVAL_TIME'] = df['ARRIVAL_TIME'].fillna(0)
    df['ARRIVAL_DELAY'] = df['ARRIVAL_DELAY'].fillna(0)
    df['CANCELLATION_REASON'] = df['CANCELLATION_REASON'].fillna('N')
    df['AIR_SYSTEM_DELAY'] = df['AIR_SYSTEM_DELAY'].fillna(0)
    df['SECURITY_DELAY'] = df['SECURITY_DELAY'].fillna(0)
    df['AIRLINE_DELAY'] = df['AIRLINE_DELAY'].fillna(0)
    df['LATE_AIRCRAFT_DELAY'] = df['LATE_AIRCRAFT_DELAY'].fillna(0)
    df['WEATHER_DELAY'] = df['WEATHER_DELAY'].fillna(0)

    df['FLIGHT_NUMBER'] = df['FLIGHT_NUMBER'].astype(int) 
    df['DEPARTURE_DELAY'] = df['DEPARTURE_DELAY'].astype(int) 
    df['ELAPSED_TIME'] = df['ELAPSED_TIME'].astype(int) 
    df['AIR_TIME'] = df['AIR_TIME'].astype(int) 
    df['DISTANCE'] = df['DISTANCE'].astype(int) 
    df['ARRIVAL_DELAY'] = df['ARRIVAL_DELAY'].astype(int) 
    df['DIVERTED'] = df['DIVERTED'].astype(int) 
    df['CANCELLED'] = df['CANCELLED'].astype(int) 
    df['AIR_SYSTEM_DELAY'] = df['AIR_SYSTEM_DELAY'].astype(int) 
    df['SECURITY_DELAY'] = df['SECURITY_DELAY'].astype(int) 
    df['AIRLINE_DELAY'] = df['AIRLINE_DELAY'].astype(int) 
    df['LATE_AIRCRAFT_DELAY'] = df['LATE_AIRCRAFT_DELAY'].astype(int) 
    df['WEATHER_DELAY'] = df['WEATHER_DELAY'].astype(int) 

    df['SCHEDULED_DEPARTURE'] = df['SCHEDULED_DEPARTURE'].astype(int) 
    df['DEPARTURE_TIME'] = df['DEPARTURE_TIME'].astype(int) 
    df['SCHEDULED_TIME'] = df['SCHEDULED_TIME'].astype(int) 
    df['SCHEDULED_ARRIVAL'] = df['SCHEDULED_ARRIVAL'].astype(int) 
    df['ARRIVAL_TIME'] = df['ARRIVAL_TIME'].astype(int) 

    print(df)

    df = df.drop_duplicates(subset=['DATE', 'AIRLINE', 'FLIGHT_NUMBER'], keep='first')

    print(df)
    
    nan_count = df.isna().sum()
    print(nan_count)

    df.to_csv("delays.csv", sep=',')


