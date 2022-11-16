library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(ggthemes)

df <- read_csv("data/Housing Characteristics of DC Wards.csv")

df <- df[, c(1, 2, 5:10, 12:27)]
df <- df[, -c(2, 9, 17)]

colnames(df) <- c(
  "ward", 1, 2, 3, 4, "5 or more", 0, "15% - 19.9%", "20% - 24.9%", "25% - 29.9%",
  "30% - 34.9%", "35% or more", "less than 15%", "not computed", "$1000 - $1499",
  "$1500 - $1999", "$2000 - 2499$", "$2500 - $2999", "$3000 or more",
  "$500 - $999", "less than $500"
)



v1 <-
  ggplot(rp, aes(fill = rent_percentage, y = count_rp, x = ward)) +
  geom_bar(position = "stack", stat = "identity") +
  scale_fill_brewer(palette = "OrRd") +
  labs(
    x = "Ward", y = "Number of Households", fill = "Rent/Income Percentage",
    title = "Rent Percentage"
  ) +
  theme_tufte() +
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


p <-
  plot_ly(df, type = "bar") %>%
  # bedroom
  add_trace(
    visible = T, x = ~ward, y = ~ df$`0`, name = 0, marker = list(color = "#fef0d9"),
    hovertemplate = "</br> <b>0 bedroom</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = T, x = ~ward, y = ~ df$`1`, name = 1, marker = list(color = "#fdd49e"),
    hovertemplate = "</br> <b>1 bedroom</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = T, x = ~ward, y = ~ df$`2`, name = 2, marker = list(color = "#fdbb84"),
    hovertemplate = "</br> <b>2 bedrooms</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = T, x = ~ward, y = ~ df$`3`, name = 3, marker = list(color = "#fc8d59"),
    hovertemplate = "</br> <b>3 bedrooms</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = T, x = ~ward, y = ~ df$`4`, name = 4, marker = list(color = "#ef6548"),
    hovertemplate = "</br> <b>4 bedrooms</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = T, x = ~ward, y = ~ df$`5 or more`, name = "5 or more", marker = list(color = "#d7301f"),
    hovertemplate = "</br> <b>5 or more bedrooms</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  # rent percentage
  add_trace(
    visible = F, x = ~ward, y = ~ df$`not computed`, name = "not computed", marker = list(color = "#fef0d9"),
    hovertemplate = "</br> <b>Not Computed</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = F, x = ~ward, y = ~ df$`less than 15%`, name = "less than 15%", marker = list(color = "#fdd49e"),
    hovertemplate = "</br> <b>less than 15%</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = F, x = ~ward, y = ~ df$`15% - 19.9%`, name = "15% - 19.9%", marker = list(color = "#fdbb84"),
    hovertemplate = "</br> <b>15% - 19.9%</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = F, x = ~ward, y = ~ df$`20% - 24.9%`, name = "20% - 24.9%", marker = list(color = "#fc8d59"),
    hovertemplate = "</br> <b>20% - 24.9%</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = F, x = ~ward, y = ~ df$`25% - 29.9%`, name = "25% - 29.9%", marker = list(color = "#ef6548"),
    hovertemplate = "</br> <b>25% - 29.9%</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = F, x = ~ward, y = ~ df$`30% - 34.9%`, name = "30% - 34.9%", marker = list(color = "#d7301f"),
    hovertemplate = "</br> <b>30% - 34.9%</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = F, x = ~ward, y = ~ df$`35% or more`, name = "35% or more", marker = list(color = "#990000"),
    hovertemplate = "</br> <b>35% or more</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  # rent
  add_trace(
    visible = F, x = ~ward, y = ~ df$`less than $500`, name = "less than $500", marker = list(color = "#fef0d9"),
    hovertemplate = "</br> <b>less than $500</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = F, x = ~ward, y = ~ df$`$500 - $999`, name = "$500 - $999", marker = list(color = "#fdd49e"),
    hovertemplate = "</br> <b>$500 - $999</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = F, x = ~ward, y = ~ df$`$1000 - $1499`, name = "$1000 - $1499", marker = list(color = "#fdbb84"),
    hovertemplate = "</br> <b>$1000 - $1499</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = F, x = ~ward, y = ~ df$`$1500 - $1999`, name = "$1500 - $1999", marker = list(color = "#fc8d59"),
    hovertemplate = "</br> <b>$1500 - $1999</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = F, x = ~ward, y = ~ df$`$2000 - 2499$`, name = "$2000 - 2499$", marker = list(color = "#ef6548"),
    hovertemplate = "</br> <b>$2000 - 2499$</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = F, x = ~ward, y = ~ df$`$2500 - $2999`, name = "$2500 - $2999", marker = list(color = "#d7301f"),
    hovertemplate = "</br> <b>$2500 - $2999</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  add_trace(
    visible = F, x = ~ward, y = ~ df$`$3000 or more`, name = "$3000 or more", marker = list(color = "#990000"),
    hovertemplate = "</br> <b>$3000 or more</b> <br> Number of Households: %{y} </br> Ward: %{x}"
  ) %>%
  layout(
    title = list(text = "<b> Housing Conditions in DC Wards </b>"),
    yaxis = list(
      title = "<b> Number of Households </b>",
      showgrid = FALSE,
      showline = FALSE,
      showticklabels = TRUE,
      zeroline = FALSE,
      linewidth=1
    ),
    xaxis = list(
      title = "<b> Wards </b>",
      showgrid = FALSE,
      showline = FALSE,
      showticklabels = TRUE,
      zeroline = FALSE,
      linewidth=1
    ),
    barmode = "stack"
  ) %>%
  layout(
    updatemenus = list(
      list(buttons = list(
        list(
          method = "restyle",
          args = list("visible", list(
            TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
            FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
            FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE
          )),
          label = "Number of Bedrooms"
        ),
        list(
          method = "restyle",
          args = list("visible", list(
            FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
            TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE,
            FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE
          )),
          label = "Rent/Income (%)"
        ),
        list(
          method = "restyle",
          args = list("visible", list(
            FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
            FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE,
            TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE
          )),
          label = "Monthly Rent ($)"
        )
      ))
    )
  )

htmlwidgets::saveWidget(as_widget(p), "html_viz/housing.html", selfcontained = TRUE)
