# Analyzing crime data and economic characteristics of wards in Washington, D.C.

# %%
# loading packages
import pandas as pd
import plotly.graph_objects as go
import plotly.express as px
import plotly.io as pio
from plotly.subplots import make_subplots

pio.renderers.default = "browser"
pio.templates.default = "plotly_white"

# %%
# loading data
crime_num_2020 = pd.read_csv("data/dc_violent_crimes.csv")
eco_characteristics = pd.read_csv("data/Economic Characteristics of DC Wards.csv")

# %%
# Merge the two datasets
merged_data = pd.merge(
    crime_num_2020, eco_characteristics, left_on="WARD", right_on="Ward"
)

# %%
# subset the data only will be graphed
statistics = merged_data[
    [
        "WARD",
        "violent_rate",
        "EMPLOYMENT STATUS: Civilian labor force: Unemployment Rate",
        "INCOME AND BENEFITS (IN 2019 INFLATION-ADJUSTED DOLLARS): Total households: Mean household income (dollars)",
        "INCOME AND BENEFITS (IN 2019 INFLATION-ADJUSTED DOLLARS): Total households: Median household income (dollars)",
    ]
]
## rename the columns
statistics.columns = [
    "ward",
    "Crime Per 100K",
    "Unemployment Rate",
    "Mean Income",
    "Median Income",
]

# multiply the crime rate column by 100 to get the crime rate in percent and round to 1 decimal place
statistics["Crime Per 100K"] = statistics["Crime Per 100K"].apply(
    lambda x: round(x * 1000000, 0)
)

# make the data tidy
statistics = pd.melt(
    statistics, id_vars=["ward"], var_name="statistic", value_name="value"
)

## subset the data to two DFs for two graphs
stat_income = statistics.loc[
    (statistics["statistic"] == "Mean Income")
    | (statistics["statistic"] == "Median Income")
]

stat_unemployment = statistics.loc[(statistics["statistic"] == "Unemployment Rate")]

stat_crime_per_100k = statistics.loc[(statistics["statistic"] == "Crime Per 100K")]

# %%
# graph mean and median income per wards
income_fig = px.bar(
    stat_income,
    x="ward",
    y="value",
    color="statistic",
    color_discrete_map={"Mean Income": "#fdd49e", "Median Income": "#ef6548"},
    barmode="group",
    title="<b>Mean and Median Income per Ward</b>",
    hover_name="statistic",
    hover_data={"statistic": False},
    labels={
        "value": "<b>Dollars</b>",
        "ward": "<b>Ward</b>",
        "statistic": "<b>Statistic</b>",
    },
)
income_fig.update_xaxes(
    type="category", showgrid=False, showline=True, linecolor="#000000", linewidth=1
)
income_fig.update_yaxes(showgrid=False, showline=True, linecolor="#000000", linewidth=1)
income_fig.update_layout(font_family="serif", font_size=16, title_x=0.5)
income_fig.write_html("html_viz/dc_income_fig.html")


# %%
# graph crime rate and unemployment rate per wards
unemployment_fig = px.bar(
    stat_unemployment,
    x="ward",
    y="value",
    color="statistic",
    color_discrete_map={"Unemployment Rate": "#ef6548"},
    barmode="group",
    title="<b>Unemployment Rate per Ward</b>",
    hover_name="statistic",
    hover_data={"statistic": False},
    labels={
        "value": "<b>Unemployment Rate(%)</b>",
        "ward": "<b>Ward</b>",
        "statistic": "<b>Statistic</b>",
    },
)
unemployment_fig.update_xaxes(
    type="category", showgrid=False, showline=True, linecolor="#000000", linewidth=1
)
unemployment_fig.update_yaxes(
    showgrid=False, showline=True, linecolor="#000000", linewidth=1
)
unemployment_fig.update_layout(font_family="serif", font_size=16, title_x=0.5)

# %%
# graph violent crime per 100k population per wards
violent_crime_per_100K_fig = px.bar(
    stat_crime_per_100k,
    x="ward",
    y="value",
    color="statistic",
    color_discrete_map={"Crime Per 100K": "#ef6548"},
    barmode="group",
    title="<b>Crime Per 100K per Ward</b>",
    hover_name="statistic",
    hover_data={"statistic": False},
    labels={
        "value": "<b>Crimes Per 100K Population</b>",
        "ward": "<b>Ward</b>",
        "statistic": "<b>Statistic</b>",
    },
)
violent_crime_per_100K_fig.update_xaxes(
    type="category",
    showgrid=False,
    showline=True,
    linecolor="#000000",
    linewidth=1,
)
violent_crime_per_100K_fig.update_yaxes(
    showgrid=False,
    showline=True,
    linecolor="#000000",
    linewidth=1,
)
violent_crime_per_100K_fig.update_layout(font_family="serif", font_size=16, title_x=0.5)
# %%

# For as many traces that exist per Express figure, get the traces from each plot and store them in an array.
# This is essentially breaking down the Express fig into it's traces
figure1_traces = []
figure2_traces = []
for trace in range(len(unemployment_fig["data"])):
    figure1_traces.append(unemployment_fig["data"][trace])
for trace in range(len(violent_crime_per_100K_fig["data"])):
    figure2_traces.append(violent_crime_per_100K_fig["data"][trace])

# Create a 1x2 subplot
this_figure = make_subplots(
    rows=1,
    cols=2,
    subplot_titles=(
        "<b>Unemployment Rate per Ward(%)</b>",
        "<b>Violent Crime Per 100K per Ward</b>",
    ),
)

# Get the Express fig broken down as traces and add the traces to the proper plot within in the subplot
for traces in figure1_traces:
    this_figure.append_trace(traces, row=1, col=1)
for traces in figure2_traces:
    this_figure.append_trace(traces, row=1, col=2)


# Mimicking the tufte style
this_figure.update_yaxes(
    showgrid=False,
    showline=True,
    linecolor="#000000",
    linewidth=1,
)

violent_crime_per_100K_fig.update_xaxes(
    type="category",
    showgrid=False,
    showline=True,
    linecolor="#000000",
    linewidth=1,
)

this_figure.update_layout(
    font_family="serif", font_size=16, title_x=0.5, showlegend=False
)

# the subplot as shown in the above image
this_figure.write_html("html_viz/dc_unemployment_crime.html")

# %%
