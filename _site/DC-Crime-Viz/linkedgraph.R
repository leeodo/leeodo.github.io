# load packages
library(tidyverse)
library(dplyr)
library(esquisse)
library(plotly)
library(chron)
library(snakecase)
library(processx)
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(gganimate) # for animating your plot
library(scales)
library(animation)
library(ggiraph)
library(remotes)
library(crosstalk)
# library(DCmapR)
esquisser(violent_crime_race)
# creating linked graph based on
# https://www.infoworld.com/article/3626911/easy-interactive-ggplot-graphs-in-r-with-ggiraph.html

violent_crime_race <- read_csv("data/violent_crime_race")
view(violent_crime_race)

t <- list(
  family = "sans serif",
  size = 16L,
  face = "bold"
)
f <- list(
  family = "sans serif",
  size = 13L,
  face = "bold"
)

shared_data <- SharedData$new(violent_crime_race)
p3 <- violent_crime_race %>%
  plot_ly(x = ~shareof_white, y = ~vcrime_rate)
p3 <- add_markers(p3, color = I("#d7301f"), size = 2)

p1 <- violent_crime_race %>%
  plot_ly(x = ~shareof_black, y = ~vcrime_rate)
p1 <- add_markers(p1, color = I("#990000"), size = 2)
vcrime_byrace <- subplot(p1, p3) %>%
  layout(
    title = list(text = "Violent Crime Rate per 100,000 People by Demographic ", font = t),
    yaxis = list(title = "Violent Crime Rate per 100,000 People by Demographic", font = f)
  )
annotations <- list(
  list(
    x = 0.2,
    y = -.08,
    text = "Share of Black (%)", font = f,
    xref = "paper",
    yref = "paper",
    xanchor = "center",
    yanchor = "bottom",
    showarrow = FALSE
  ),
  list(
    x = 0.8,
    y = -0.08,
    text = "Share of White (%)", font = f,
    xref = "paper",
    yref = "paper",
    xanchor = "center",
    anchor = "bottom",
    showarrow = FALSE
  )
)
fig <- vcrime_byrace %>% layout(annotations = annotations) 
fig <- fig %>% layout(showlegend = FALSE)
fig
htmlwidgets::saveWidget(as_widget(fig), "html_viz/linked_race and crime.html")
