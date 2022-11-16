import pandas as pd
import glob
import os
import plotly.express as px
import plotly.graph_objects as go
import plotly.io as pio

pio.renderers.default = "browser"
pio.templates.default = "plotly_white"


df = pd.read_csv("data/dc_num_crimes_ward_type.csv")

df_tmp = df.groupby(["REPORT_DAT", "WARD"], as_index=False)[
    "num_crimes_ward_type"
].sum()
df_tmp["WARD"] = df_tmp["WARD"].astype(int)

df1 = df_tmp.loc[df_tmp["WARD"] == 1]
df2 = df_tmp.loc[df_tmp["WARD"] == 2]
df3 = df_tmp.loc[df_tmp["WARD"] == 3]
df4 = df_tmp.loc[df_tmp["WARD"] == 4]
df5 = df_tmp.loc[df_tmp["WARD"] == 5]
df6 = df_tmp.loc[df_tmp["WARD"] == 6]
df7 = df_tmp.loc[df_tmp["WARD"] == 7]
df8 = df_tmp.loc[df_tmp["WARD"] == 8]


## Vis


ward1 = go.Scatter(
    x=df1["REPORT_DAT"][:2],
    y=df1["num_crimes_ward_type"][:2],
    mode="lines",
    line=dict(width=1.5),
    name="ward 1",
)
ward2 = go.Scatter(
    x=df2["REPORT_DAT"][:2],
    y=df2["num_crimes_ward_type"][:2],
    mode="lines",
    line=dict(width=1.5),
    name="ward 2",
)
ward3 = go.Scatter(
    x=df3["REPORT_DAT"][:2],
    y=df3["num_crimes_ward_type"][:2],
    mode="lines",
    line=dict(width=1.5),
    name="ward 3",
)
ward4 = go.Scatter(
    x=df4["REPORT_DAT"][:2],
    y=df4["num_crimes_ward_type"][:2],
    mode="lines",
    line=dict(width=1.5),
    name="ward 4",
)
ward5 = go.Scatter(
    x=df5["REPORT_DAT"][:2],
    y=df5["num_crimes_ward_type"][:2],
    mode="lines",
    line=dict(width=1.5),
    name="ward 5",
)
ward6 = go.Scatter(
    x=df6["REPORT_DAT"][:2],
    y=df6["num_crimes_ward_type"][:2],
    mode="lines",
    line=dict(width=1.5),
    name="ward 6",
)
ward7 = go.Scatter(
    x=df7["REPORT_DAT"][:2],
    y=df7["num_crimes_ward_type"][:2],
    mode="lines",
    line=dict(width=1.5),
    name="ward 7",
)
ward8 = go.Scatter(
    x=df8["REPORT_DAT"][:2],
    y=df8["num_crimes_ward_type"][:2],
    mode="lines",
    line=dict(width=1.5),
    name="ward 8",
)


frames = [
    dict(
        data=[
            dict(
                type="scatter",
                x=df1["REPORT_DAT"][: k + 1],
                y=df1["num_crimes_ward_type"][: k + 1],
            ),
            dict(
                type="scatter",
                x=df2["REPORT_DAT"][: k + 1],
                y=df2["num_crimes_ward_type"][: k + 1],
            ),
            dict(
                type="scatter",
                x=df3["REPORT_DAT"][: k + 1],
                y=df3["num_crimes_ward_type"][: k + 1],
            ),
            dict(
                type="scatter",
                x=df4["REPORT_DAT"][: k + 1],
                y=df4["num_crimes_ward_type"][: k + 1],
            ),
            dict(
                type="scatter",
                x=df5["REPORT_DAT"][: k + 1],
                y=df5["num_crimes_ward_type"][: k + 1],
            ),
            dict(
                type="scatter",
                x=df6["REPORT_DAT"][: k + 1],
                y=df6["num_crimes_ward_type"][: k + 1],
            ),
            dict(
                type="scatter",
                x=df7["REPORT_DAT"][: k + 1],
                y=df7["num_crimes_ward_type"][: k + 1],
            ),
            dict(
                type="scatter",
                x=df8["REPORT_DAT"][: k + 1],
                y=df8["num_crimes_ward_type"][: k + 1],
            ),
        ],
        traces=[0, 1, 2, 3, 4, 5, 6, 7],
    )
    for k in range(1, len(df1) - 1)
]

layout = go.Layout(
    width=2000,
    height=800,
    showlegend=False,
    hovermode="x unified",
    updatemenus=[
        dict(
            type="buttons",
            showactive=False,
            y=1.05,
            x=1.15,
            xanchor="right",
            yanchor="top",
            pad=dict(t=0, r=10),
            buttons=[
                dict(
                    label="Play",
                    method="animate",
                    args=[
                        None,
                        dict(
                            frame=dict(duration=1, redraw=False),
                            transition=dict(duration=0),
                            fromcurrent=True,
                            mode="immediate",
                        ),
                    ],
                )
            ],
        ),
        dict(
            type="buttons",
            direction="left",
            buttons=list(
                [
                    dict(
                        args=[{"yaxis.type": "linear"}],
                        label="LINEAR",
                        method="relayout",
                    ),
                    dict(args=[{"yaxis.type": "log"}], label="LOG", method="relayout"),
                ]
            ),
        ),
    ],
)
layout.update(
    xaxis=dict(range=["2014-02-17", "2022-02-15"], autorange=False),
    yaxis=dict(range=[0, 80], autorange=False),
)

fig = go.Figure(
    data=[ward1, ward2, ward3, ward4, ward5, ward6, ward7, ward8],
    frames=frames,
    layout=layout,
)

fig.update_layout(
    {
        "title": "Crime Incidents in DC Wards from Feb 2014 to Feb 2022",
        "xaxis": {"title": "Time"},
        "yaxis": {"title": "Number of Crimes"},
        "legend": {"title": "Wards"},
        "showlegend": True,
    }
)


fig.show()

fig.write_html("html_viz/dc_2014_2022.html")
