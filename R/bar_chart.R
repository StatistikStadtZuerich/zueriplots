# SSZ Bar Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)

# Data
URL <- "https://data.stadt-zuerich.ch/dataset/bev_bestand_jahr_od3243/download/BEV324OD3243.csv"
df <- fread(URL, encoding = "UTF-8")

# Define Colors
color <- get_zuericolors(palette = "qual6", nth = 1)

# Plot
options(scipen = 999)
plot <- ggplot(data = df,
       aes(x = StichtagDatJahr,
           y = AnzBestWir)) +
  geom_bar(stat = "identity",
           fill = color) +
  labs(title = "Wirtschaftliche Bevölkerung der Stadt Zürich",
       subtitle = "seit 1901",
       x = " ",
       y = "Anzahl Personen",
       caption = "Quelle: BVS, Statistik Stadt Zürich") +
  ssz_theme(grid_lines = "y") +
  theme(axis.title.y = element_text(
    margin = margin(t = 0, r = -27, b = 0, l = 0)
  ))

# Save Plot
ggsave(
  paste0(here(), "/plots/bar_chart.png"),
  plot,
  width = 10,
  height = 6
)