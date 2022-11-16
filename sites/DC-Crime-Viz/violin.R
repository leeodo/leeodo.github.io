library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(ggthemes)


df <- read_csv("data/dc_num_crimes_ward_type.csv")



df %>%
  filter(REPORT_DAT >= "2020-01-01" & REPORT_DAT <= "2021-01-01") %>%
  ggplot() +
  aes(y = `offense-text`, x = REPORT_DAT, fill = `offense-text`, color = `offense-text`) +
  geom_violin(adjust = .001, scale = "width") +
  scale_fill_hue(direction = 1) +
  scale_color_hue(direction = 1) +
  scale_fill_brewer(palette = "OrRd") +
  scale_color_brewer(palette = "OrRd") +
  labs(
    y = "Type of Crimes", x = "Time",
    title = "Distributions of Crimes in DC 2020", fill = "Type of Crimes", color = "Type of Crimes"
  ) +
  theme_tufte() +
  theme(
    plot.title = element_text(size = 17L, face = "bold", hjust = .5),
    axis.title.y = element_text(size = 13L, face = "bold"),
    axis.title.x = element_text(size = 13L, face = "bold")
  )


vis

#& num_crimes_ward_type <= 20
#scale_y_continuous(breaks = seq(1, 20, 1), limits = c(1, 20)) +

#vis <-
#  ggplotly(
#    p = vis,
#    width = NULL,
#    height = NULL,
#    tooltip = "all",
#    dynamicTicks = FALSE,
#    layerData = 1,
#    originalData = TRUE,
#  )




# htmlwidgets::saveWidget(as_widget(vis), "violin.html")
