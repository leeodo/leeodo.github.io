setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# lintr::lint("social_characteristic_analysis.R")
# Rae Zhang

library(dplyr)
library(readxl)
library(esquisse)
library(dplyr)
library(tidyr)
library(tidyverse)
library(ggplot2)
library(plotly)
library(snakecase)

# read data and calculate crime rate
df <- read.csv("data/Social Characteristics of DC Wards.csv") %>%
  rename_all(to_snake_case)

demographic <- read.csv("data/Demographic Characteristics of DC Wards.csv") %>%
  rename_all(to_snake_case) %>%
  select(1, 10) %>%
  rename(total_population = hispanic_or_latino_and_race_total_population)

total_crimes_by_ward <- read.csv("data/dc_num_crimes_ward_2020.csv") %>%
  rename_all(to_snake_case)

violent_crimes_offense <- read.csv("data/num_violentcrimes_offense_2020.csv") %>%
  rename_all(to_snake_case)

violent_crimes_by_ward <- read.csv("data/num_violentcrimes_ward_2020.csv") %>%
  rename_all(to_snake_case) %>%
  rename(violent_crime = count)

## combine data together
df <- read.csv("data/Social Characteristics of DC Wards.csv") %>%
  rename_all(to_snake_case) %>%
  left_join(demographic, by = "ward") %>%
  left_join(total_crimes_by_ward, by = "ward") %>%
  select(161, 162, 43:52, 105, 99:108, 1) %>%
  rename(education_attainment = 3,
         highschool_dropout = 4,
         associates_degree = 5,
         bachelors_degree = 6,
         bachelors_or_higher = 7,
         graduate_or_higher = 8,
         highschool_degree = 9,
         highschool_or_higher = 10,
         below_highschool = 11,
         college_dropout = 12) %>%
  select(23, 1:12) %>%
  left_join(violent_crimes_by_ward, by = "ward") %>%
  select(1, 14, 2:4, 9, 11, 12, 5) %>%
  rowwise() %>%
  mutate(no_highschool_degree = sum(below_highschool, highschool_dropout,
                                    na.rm = T)) %>%
  select(1, 2, 3, 5, 10, 7) %>%
  mutate(`Violent Crime Rate per 1,000` = 1000 * violent_crime / total_population) %>%
  mutate(`No High School Degree` = 100 * (1 - (highschool_or_higher / total_population))) %>%
  pivot_longer(cols = c(7, 8),
               names_to = "Statistic",
               values_to = "population") %>%
  mutate(ward = as.factor(ward)) %>%
  mutate(population = round(population, 1))

graph <- ggplot(df) +
  aes(
    x = ward,
    fill = `Statistic`,
    colour = `Statistic`,
    weight = population,
    text = paste(
      "Percentage Rate:", population,
      "\nWard:", ward)
  ) + 
  geom_bar(position = "dodge") +
  scale_fill_manual(
    values = c(`No High School Degree` = "#FDD49E",
               `Violent Crime Rate per 1,000` = "#D7301F")
  ) +
  scale_color_manual(
    values = c(`No High School Degree` = "#FDD49E",
               `Violent Crime Rate per 1,000` = "#D7301F")
  ) +
  labs(
    y = "%",
    title = "Violent Crime Rate and Education Status per Ward",
    fill = "Statistic",
    color = "Statistic"
  ) +
  ggthemes::theme_tufte() +
  theme(plot.title = element_text(size = 16L, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(size = 15L, face = "italic", hjust = 0.5),
        plot.caption = element_text(size = 14L),
        axis.title.y = element_text(size = 13L, face = "bold"),
        axis.title.x = element_text(size = 13L, face = "bold"),
        axis.text.x = element_text(face = "bold", size = 11L),
        axis.text.y = element_text(face = "bold", size = 11L),
        legend.text = element_text(size = 11L)) +
  theme(strip.text.x = element_text(size = 11L, face = "bold")) +
  theme(strip.text.y = element_text(size = 11L))

graph <- ggplotly(graph, tooltip = c("text"))
htmlwidgets::saveWidget(graph,
                        "html_viz/Violent_Crime_and_Education_Status.html")


# make second graph
df2 <- read.csv("data/Social Characteristics of DC Wards.csv") %>%
  rename_all(to_snake_case) %>%
  left_join(demographic, by = "ward") %>%
  left_join(total_crimes_by_ward, by = "ward") %>%
  select(161, 162, 43:52, 105, 99:108, 1) %>%
  rename(`Education Attainment` = 3,
         `Highschool Dropout` = 4,
         `Associates Degree` = 5,
         `Bachelors Degree` = 6,
         `Bachelors Or Higher` = 7,
         `Graduate Degree or Higher` = 8,
         `Highschool Degree` = 9,
         `Highschool or Higher` = 10,
         `Below Highschool` = 11,
         `College Dropout` = 12) %>%
  select(23, 1:12) %>%
  left_join(violent_crimes_by_ward, by = "ward") %>%
  select(1, 14, 2:4, 10, 6, 7, 9, 11, 12, 5) %>%
  select(1, 6:9) %>%
  pivot_longer(cols = c(2: 5),
               names_to = "Education Status",
               values_to = "Population") %>%
  mutate(ward = as.factor(ward))

graph2 <- ggplot(df2) +
  aes(
    x = ward,
    fill = `Education Status`,
    colour = `Education Status`,
    weight = Population
  ) +
  geom_bar() +
  scale_fill_manual(
    values = c(`Associates Degree` = "#FFC697",
               `Bachelors Degree` = "#FC8D59",
               `Graduate Degree or Higher` = "#EF6548",
               `Highschool Degree` = "#FFDFAE")
  ) +
  scale_color_manual(
    values = c(`Associates Degree` = "#FFC697",
               `Bachelors Degree` = "#FC8D59",
               `Graduate Degree or Higher` = "#EF6548",
               `Highschool Degree` = "#FFDFAE")
  ) +
  labs(
    y = "Population",
    x = "Ward",
    title = "Education Status Breakdown by Ward"
  ) +
  coord_flip() +
  ggthemes::theme_tufte() +
  theme(plot.title = element_text(size = 16L, face = "bold", hjust = 0.5),
        plot.subtitle = element_text(size = 15L, face = "italic", hjust = 0.5),
        plot.caption = element_text(size = 14L),
        axis.title.y = element_text(size = 13L, face = "bold"),
        axis.title.x = element_text(size = 13L, face = "bold"),
        axis.text.x = element_text(face = "bold", size = 11L),
        axis.text.y = element_text(face = "bold", size = 11L),
        legend.text = element_text(size = 11L)) +
  theme(strip.text.x = element_text(size = 11L, face = "bold")) +
  theme(strip.text.y = element_text(size = 11L))

graph2 <- ggplotly(graph2, tooltip = c("colour", "x", "weight"))
htmlwidgets::saveWidget(graph2,
                        "html_viz/Education_Status_Breakdown.html")

# graph 3
df3 <- read_csv("data/dc_num_crimes_ward_type.csv") %>%
  filter(REPORT_DAT >= "2020-01-01" & REPORT_DAT <= "2020-12-31") %>%
  #aggregate(REPORT_DAT) %>%
  group_by(REPORT_DAT, `offense-text`) %>% mutate(count = n())
  

vis <-
  df3 %>%
  filter(REPORT_DAT >= "2020-01-01" & REPORT_DAT <= "2021-01-01") %>%
  ggplot() +
  aes(y = `offense-text`, x = REPORT_DAT, fill = `offense-text`, colour = `offense-text`) +
  geom_violin(adjust = .001, scale = "width") +
  scale_fill_hue(direction = 1) +
  scale_color_hue(direction = 1) +
  scale_fill_brewer(palette = "OrRd") +
  scale_color_brewer(palette = "OrRd") +
  labs(
    y = "Type of Crimes", x = "Time",
    title = "Distributions of Crimes in DC 2020", fill = "Type of Crimes", colour = "Type of Crimes"
  ) +
  ggthemes::theme_tufte() +
  theme(
    plot.title = element_text(size = 16L, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 15L, face = "italic", hjust = 0.5),
    plot.caption = element_text(size = 14L),
    axis.title.y = element_text(size = 13L, face = "bold"),
    axis.title.x = element_text(size = 13L, face = "bold"),
    axis.text.x = element_text(face = "bold", size = 11L),
    axis.text.y = element_text(face = "bold", size = 11L),
    legend.text = element_text(size = 11L)
  ) +
  theme(strip.text.x = element_text(size = 11L, face = "bold")) +
  theme(strip.text.y = element_text(size = 11L))

ggplotly(vis)
