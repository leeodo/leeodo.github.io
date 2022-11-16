# Wrangling data for DC crime data

# %%
# import packages
import pandas as pd
import datetime

datetime.datetime.strptime

# %%
# read in data
df = pd.read_csv("data/dc.csv")

# %%
# Remove time from date columns
df["START_DATE"] = pd.to_datetime(df["START_DATE"]).dt.date
df["END_DATE"] = pd.to_datetime(df["END_DATE"]).dt.date
df["REPORT_DAT"] = pd.to_datetime(df["REPORT_DAT"]).dt.date

# %%
# create a new DataFrame with number of crimes per day
num_crimes = df.groupby("REPORT_DAT").size()
num_crimes = pd.DataFrame(
    {"REPORT_DAT": num_crimes.index, "num_crimes": num_crimes.values}
)

num_crimes.to_csv("data/dc_num_crimes.csv", index=False)

# create a new DataFrame with number of individual crimes types per day
num_crimes_type = df.groupby(["REPORT_DAT", "offense-text"]).size()
num_crimes_type = pd.DataFrame(
    {
        "REPORT_DAT": num_crimes_type.index.get_level_values(0),
        "offense-text": num_crimes_type.index.get_level_values(1),
        "num_crimes_type": num_crimes_type.values,
    }
)

num_crimes_type.to_csv("data/dc_num_crimes_type.csv", index=False)

# create a new DataFrame with number of crimes per day per Ward
num_crimes_ward = df.groupby(["REPORT_DAT", "WARD"]).size()
num_crimes_ward = pd.DataFrame(
    {
        "REPORT_DAT": num_crimes_ward.index.get_level_values(0),
        "WARD": num_crimes_ward.index.get_level_values(1),
        "num_crimes_ward": num_crimes_ward.values,
    }
)

num_crimes_ward.to_csv("data/dc_num_crimes_ward.csv", index=False)

# create a new DataFrame with number of crimes per day per Ward and crime type
num_crimes_ward_type = df.groupby(["REPORT_DAT", "WARD", "offense-text"]).size()
num_crimes_ward_type = pd.DataFrame(
    {
        "REPORT_DAT": num_crimes_ward_type.index.get_level_values(0),
        "WARD": num_crimes_ward_type.index.get_level_values(1),
        "offense-text": num_crimes_ward_type.index.get_level_values(2),
        "num_crimes_ward_type": num_crimes_ward_type.values,
    }
)

num_crimes_ward_type.to_csv("data/dc_num_crimes_ward_type.csv", index=False)

# create a new DataFrame with number of crimes per day per ward in 2020
num_crimes_ward_2020 = df.groupby(["REPORT_DAT", "WARD"]).size()
num_crimes_ward_2020 = pd.DataFrame(
    {
        "REPORT_DAT": num_crimes_ward_2020.index.get_level_values(0),
        "WARD": num_crimes_ward_2020.index.get_level_values(1),
        "num_crimes_ward_2020": num_crimes_ward_2020.values,
    }
)
num_crimes_ward_2020 = num_crimes_ward_2020[
    (num_crimes_ward_2020["REPORT_DAT"] >= datetime.date(2020, 1, 1))
    & (num_crimes_ward_2020["REPORT_DAT"] <= datetime.date(2020, 12, 31))
]

num_crimes_ward_2020 = num_crimes_ward_2020.groupby(["WARD"]).sum()

num_crimes_ward_2020["WARD"] = num_crimes_ward_2020.index
num_crimes_ward_2020["WARD"] = num_crimes_ward_2020["WARD"].astype(int)

num_crimes_ward_2020.to_csv("data/dc_num_crimes_ward_2020.csv", index=False)

# create a new DataFrame with number of violent crimes per ward in 2020
num_violentcrimes_ward_2020 = df[
    (df["REPORT_DAT"] >= datetime.date(2020, 1, 1))
    & (df["REPORT_DAT"] <= datetime.date(2020, 12, 31))
    & (df["offensegroup"] == "violent")
]

num_violentcrimes_ward_2020 = num_violentcrimes_ward_2020.loc[:, ["WARD", "OFFENSE"]]
num_violentcrimes_offense_2020 = (
    num_violentcrimes_ward_2020.groupby(["WARD", "OFFENSE"])
    .size()
    .reset_index(name="count")
)
num_violentcrimes_ward_2020 = (
    num_violentcrimes_ward_2020.groupby(["WARD"]).size().reset_index(name="count")
)
num_violentcrimes_ward_2020["WARD"] = num_violentcrimes_ward_2020["WARD"].astype(int)
num_violentcrimes_offense_2020["WARD"] = num_violentcrimes_offense_2020["WARD"].astype(
    int
)
num_violentcrimes_ward_2020.to_csv("data/num_violentcrimes_ward_2020.csv", index=False)
num_violentcrimes_offense_2020.to_csv(
    "data/num_violentcrimes_offense_2020.csv", index=False
)

# %%
