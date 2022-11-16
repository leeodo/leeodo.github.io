# Building interactive maps with Leaflet

# %%
import folium
import folium.plugins
import pandas as pd
import geopandas as gpd
import datetime


# %%
# read in data
orig_data = pd.read_csv("data/dc.csv")  # dc crime data
df = pd.read_csv(
    "data/dc_num_crimes_ward_2020.csv"
)  # number of crimes per ward in 2020
df1 = pd.read_csv(
    "data/dc_num_crimes_ward_type.csv"
)  # number of crimes per ward by type
dc_gpd = gpd.read_file("Wards_from_2012.geojson")  # ward boundaries

# %%
# Merge the two dataframes
gdf = dc_gpd.merge(df, on="WARD", how="left").fillna(0)
gdf["crime_rate"] = gdf["num_crimes_ward_2020"] / gdf["POP_2011_2015"]
gdf["Violent Crime Per 100,000"] = round(gdf["crime_rate"] * 100000, 0)

# %%
# Mugleing the df1 for 2020 crime type summary
df1["REPORT_DAT"] = pd.to_datetime(df1["REPORT_DAT"]).dt.date
df1 = df1[
    (df1["REPORT_DAT"] >= datetime.date(2020, 1, 1))
    & (df1["REPORT_DAT"] <= datetime.date(2020, 12, 31))
]
df1 = df1.groupby(["WARD", "offense-text"]).sum().reset_index()
df1["WARD"] = df1["WARD"].astype(int)

violent_types = [
    "arson",
    "assault w/dangerous weapon",
    "burglary",
    "homicide",
    "robbery",
    "sex abuse",
]  # Violent Crime Names

dc_violent = df1[
    df1["offense-text"].isin(violent_types)
].reindex()  # subset violent crimes only

dc_violent = dc_violent.pivot_table(
    index="WARD", columns=["offense-text"], fill_value=0
)  # pivot wider

dc_violent.columns = dc_violent.columns.droplevel(0)  # remove top column level
dc_violent.columns.name = None  # remove name of column names
dc_violent = dc_violent.reset_index()  # reset index

gdf1 = dc_gpd.merge(dc_violent, on="WARD", how="left").fillna(0)

gdf1["violent_num"] = gdf1.iloc[:, -6:].sum(axis=1)
gdf1["violent_rate"] = round(gdf1["violent_num"] / gdf1["POP_2011_2015"], 5)
gdf1["Violent Crime Per 100,000"] = gdf1["violent_rate"] * 100000

dc_violent["violent_num"] = gdf1["violent_num"].copy()
dc_violent["violent_rate"] = gdf1["violent_rate"].copy()

dc_violent.to_csv("data/dc_violent_crimes.csv", index=False)


# %%
# DC 2020 crime map
## create a map
map = folium.Map(location=[38.9072, -77.0369], zoom_start=11)

# bind geojson data to map
variable = "num_crimes_ward_2020"

colormap = folium.LinearColormap(
    colors=[(254, 240, 217), (153, 0, 0)],
    vmin=gdf.loc[gdf[variable] > 0, variable].min(),
    vmax=gdf.loc[gdf[variable] > 0, variable].max(),
)

folium.GeoJson(
    gdf[["geometry", "WARD", variable, "Violent Crime Per 100,000"]],
    name="DC Crime Map 2020",
    style_function=lambda x: {
        "weight": 2,
        "color": "black",
        "fillColor": colormap(x["properties"][variable]),
        "fillOpacity": 0.5,
    },
    highlight_function=lambda x: {"weight": 3, "color": "black"},
    smooth_factor=0.1,
    tooltip=folium.features.GeoJsonTooltip(
        fields=[
            "WARD",
            variable,
            "Violent Crime Per 100,000",
        ],
        aliases=["WARD", "Total Crimes 2020", "Violent Crime Per 100,000"],
        labels=True,
        sticky=True,
        toLocaleString=True,
    ),
).add_to(map)

colormap.add_to(map)
# saving the map
map.save("html_viz/dc_crime_map_2020.html")


# %%
# choropleth with violent crime rate
map1 = gdf1.explore(
    column="violent_rate",  # column to explode
    tooltip=["WARD", "violent_rate", "violent_num"],  # tooltip
    scheme="naturalbreaks",  # use mapclassify's natural breaks scheme
    legend=True,  # show legend
    k=8,  # use 10 bins
    legend_kwds=dict(colorbar=True),  # use colorbar
    name="Violent Crime",  # name of the layer in the map
    cmap="OrRd",  # use the colormap
)

map1.save("html_viz/dc_violent_crime_2020.html")

# %%
# Marker Cluster
orig_data["REPORT_DAT"] = pd.to_datetime(orig_data["REPORT_DAT"]).dt.date
orig_2020 = orig_data[
    (orig_data["REPORT_DAT"] >= datetime.date(2020, 1, 1))
    & (orig_data["REPORT_DAT"] <= datetime.date(2020, 12, 31))
]

geomatry = gpd.points_from_xy(orig_2020.LONGITUDE, orig_2020.LATITUDE)

map2 = folium.Map(location=[38.9072, -77.0369], tiles="CartoDB positron", zoom_start=11)

marker_cluster = folium.plugins.MarkerCluster().add_to(map2)

for point in geomatry:
    folium.Marker(
        [point.xy[1][0], point.xy[0][0]],
        icon=folium.Icon(
            color="darkblue", icon_color="white", icon="siren-on", angle=0, prefix="fa"
        ),
    ).add_to(marker_cluster)

map2.save("html_viz/marker_cluster_2020.html")

# %%
# Heatmap
map3 = folium.Map(
    location=[38.9072, -77.0369], tiles="Cartodb dark_matter", zoom_start=11
)

colormap = folium.LinearColormap(colors=[(254, 240, 217), (153, 0, 0)], vmin=0, vmax=1)

colormap.add_to(map3)

heat_data = [[point.xy[1][0], point.xy[0][0]] for point in geomatry]

folium.plugins.HeatMap(
    heat_data,
    gradient={
        0.0: "#fef0d9",
        0.2: "#fdd49e",
        0.4: "#fdbb84",
        0.6: "#fc8d59",
        0.75: "#ef6548",
        0.9: "#d7301f",
        1.0: "#990000",
    },
).add_to(map3)

map3.save("html_viz/heatmap_2020.html")
