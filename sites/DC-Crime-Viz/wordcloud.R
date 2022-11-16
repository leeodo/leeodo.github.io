library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(ggwordcloud)
library(wordcloud2)
library(gridExtra)
library(cowplot)

data1 <- read_csv("data/dc_num_crimes_ward.csv")

par(mfrow = c(1, 2))

# First wordcloud based on location
df <- data1
df$WARD <- sub("^", "Ward ", df$WARD)

df <- df %>%
  filter(REPORT_DAT >= "2020-01-01" & REPORT_DAT <= "2021-01-01") %>%
  group_by(WARD) %>%
  summarize(num = sum(num_crimes_ward))



w1 <- wordcloud2(
  data = df,
  size = .5,
  rotateRatio = .6,
  shape = "circle",
  fontWeight = "bold",
  color = "random-dark"
)


#htmlwidgets::saveWidget(w1, "html_viz/wordcloud_ward.html", selfcontained = T)


# Second wordcloud based on crime types

data2 <- read_csv("data/dc_num_crimes_type.csv")

df2 <- data2
df2 <- df2 %>%
  filter(REPORT_DAT >= "2020-01-01" & REPORT_DAT <= "2021-01-01") %>%
  group_by(`offense-text`) %>%
  summarize(num = sum(num_crimes_type)) %>%
  mutate(num_log = log(num))

df2 <- df2[, -2]

w2 <- wordcloud2(
  data = df2,
  size = .3,
  rotateRatio = .6,
  shape = "circle",
  fontWeight = "bold",
  color = "random-dark",
  shuffle = FALSE
)

# htmlwidgets::saveWidget(w2, "wordcloud_crime.html")
