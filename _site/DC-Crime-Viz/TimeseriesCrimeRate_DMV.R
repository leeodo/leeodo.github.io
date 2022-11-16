
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


states_df <- read_csv("data/state_crime.csv")
names(states_df) <- to_snake_case(names(states_df))
str(states_df)

# create all crime as the sum of
states_df$data_total_all_crime <- states_df$data_totals_property_all + states_df$data_totals_violent_all
states_df$data_rate_all_crime <- (states_df$data_total_all_crime / states_df$data_population) * 100000

# time series data using plotly
fig <- states_df %>% plot_ly(
  type = "scatter", mode = "lines", fill = "tozeroy", fill = c("#E81B39", "#d5ab09", "#00297B"),
  line = list(width = 4)
)
fig <- fig %>% layout(autosize = F, width = 1200, height = 600, margin = list(
  l = 200,
  r = 50,
  b = 50,
  t = 200,
  pad = 20
))
# fig <- plot_ly(states_df, type = 'Area', mode = 'lines')
fig
fig <- fig %>% add_trace(
  x = ~ year[states_df$state == "District of Columbia"], y = ~ data_rate_all_crime[states_df$state == "District of Columbia"], name = "District of Columbia",
  line = list(color = "#E81B39"), fillcolor = "E81B39"
)
fig <- fig %>% add_trace(
  x = ~ year[states_df$state == "Maryland"], y = ~ data_rate_all_crime[states_df$state == "Maryland"], name = "Maryland",
  line = list(color = "#d5ab09"), fillcolor = "#d5ab09"
)
fig <- fig %>% add_trace(
  x = ~ year[states_df$state == "Virginia"], y = ~ data_rate_all_crime[states_df$state == "Virginia"], name = "Virginia",
  line = list(color = "#00297B"), fillcolor = "#00297B"
)
# fig <- fig %>% add_trace(x=~year[states_df$state=="United States"], y=~data_rate_all_crime[states_df$state=="United States"], name="United States",
# line=list(color="Orange"), fillcolor = "Orange")
fig <- fig %>% layout(
  title = list(text = "
                      Crime Rates in Washingotn DC, Maryland, & Virginia 1960 - 2019", y = 0.8), showlegend = FALSE,
  xaxis = list(title = "Years"),
  yaxis = list(title = "Crime Rates per 100,000 People")
)


fig

htmlwidgets::saveWidget(as_widget(fig), "html_viz/TimeseriesCrimeRate_DMV.html")




# animated scatter plot
esquisser(states_df)

myplot <- states_df %>%
  filter(state %in% c("Maryland", "Virginia", "District of Columbia")) %>%
  ggplot() +
  aes(
    x = year,
    y = data_rates_violent_murder,
    colour = state,
    size = data_population
  ) +
  geom_point(shape = "circle") +
  # scale_color_hue(value= c("Red", "Yellow", "Blue"))+
  scale_color_manual(
    breaks = c("Maryland", "Virginia", "District of Columbia", "United States"),
    values = c("#d5ab09", "#00297B", "#E81B39", "Orange")
  ) +
  labs(
    # x = "Year ",
    y = "Violent Murder Crime Rates per 100k",
    title = "Violent Murder Rates per 100k Maryland,
    Washington DC,&
    Virginia,
    1960-2019",
    subtitle = "DC has the Highest Murder Crime Rates, Dispite having the Smallest Population, When Compared to Virgina and Maryland. ",
    caption = "Source: ",
    colour = "State",
    size = "Population Size",
  ) +
  theme_bw() +
  theme(
    plot.title = element_text(
      size = 27L,
      face = "bold",
      hjust = 0.5
    ),
    plot.subtitle = element_text(
      size = 17L,
      face = "italic",
      hjust = 0.5
    ),
    axis.title.y = element_text(face = "bold"),
    axis.title.x = element_text(face = "bold")
  ) +
  scale_x_continuous(breaks = seq(1960, 2020, 5)) #+
# scale_y_continuous(name="Stopping distance", limits=c(0, 150))
# scale_x_continuous(limits = c(1960,2019, 5))
myplot
## the gganimate part of code
animateplot <- myplot + transition_time(year) +
  shadow_mark() + scale_x_continuous(limits = c(1960, 2019)) +
  # labs(title = 'Year : {frame_time}')+
  # view_follow(fixed_y = TRUE)+
  xlab("Year") + ylab("Prevalence per 100,000")

animate(animateplot, width = 1600, height = 600)
anim_save("static_viz/MurderCrime_DMV.gif")
