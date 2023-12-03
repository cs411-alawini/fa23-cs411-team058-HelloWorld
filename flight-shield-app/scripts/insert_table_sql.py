import pandas as pd

if __name__ == "__main__":
    df = pd.read_csv("delays.csv")

    print(df)

    create_table_stmt = """Create Table delays(
 DATE VARCHAR(255),
 AIRLINE VARCHAR(3) ,
 FLIGHT_NUMBER INT ,
 SCHEDULED_DEPARTURE INT,
 DEPARTURE_TIME INT,
 DEPARTURE_DELAY INT,
 SCHEDULED_TIME INT,
 ELAPSED_TIME INT,
 AIR_TIME INT,
 DISTANCE INT,
 SCHEDULED_ARRIVAL INT,
 ARRIVAL_TIME INT,
 ARRIVAL_DELAY INT,
 DIVERTED INT,
 CANCELLED INT,
 CANCELLATION_REASON VARCHAR(1),
 AIR_SYSTEM_DELAY INT,
 SECURITY_DELAY INT,
 AIRLINE_DELAY INT,
 LATE_AIRCRAFT_DELAY INT,
 WEATHER_DELAY INT,
PRIMARY KEY(DATE, AIRLINE, FLIGHT_NUMBER),
FOREIGN KEY(DATE, AIRLINE,FLIGHT_NUMBER) REFERENCES flights(DATE, AIRLINE,FLIGHT_NUMBER)
);"""

    insert_stmts = []

    for index, row in df.iterrows():
        # print(row)
        insert_stmt = f'INSERT INTO delays VALUES (\"{row["DATE"]}\", \"{row["AIRLINE"]}\", {row["FLIGHT_NUMBER"]}, {row["SCHEDULED_DEPARTURE"]}, {row["DEPARTURE_TIME"]}, {row["DEPARTURE_DELAY"]}, {row["SCHEDULED_TIME"]}, {row["ELAPSED_TIME"]}, {row["DIVERTED"]}, {row["DISTANCE"]}, {row["SCHEDULED_ARRIVAL"]}, {row["ARRIVAL_TIME"]}, {row["ARRIVAL_DELAY"]}, {row["DIVERTED"]}, {row["CANCELLED"]}, \"{row["CANCELLATION_REASON"]}\", {row["AIR_SYSTEM_DELAY"]}, {row["SECURITY_DELAY"]}, {row["AIRLINE_DELAY"]}, {row["LATE_AIRCRAFT_DELAY"]}, {row["WEATHER_DELAY"]});'
        # print(insert_stmt)
        insert_stmts.append(insert_stmt)

    all_statements = create_table_stmt + "\n".join(insert_stmts)

    file_path = "delays.sql"

    with open(file_path, "w") as f:
        f.write(all_statements)