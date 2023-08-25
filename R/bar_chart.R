# SSZ Bar Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(extrafont)

# Data
URL <- "https://data.stadt-zuerich.ch/dataset/bev_bestand_jahr_od3243/download/BEV324OD3243.csv"
df <- fread(URL, encoding = "UTF-8")

# Define Colors
color <- get_zuericolors(palette = "qual6", nth = 1)

# Import HelveticaNeueLTPro
font_import(pattern = "HelveticaNeueLTPro-Roman.ttf")
loadfonts(device = "win")
windowsFonts()

# Plot
plot <- ggplot(data = df,
       aes(x = StichtagDatJahr,
           y = AnzBestWir)) +
  geom_bar(stat = "identity",
           fill = color) +
  scale_y_continuous(labels = function(x) format(x, 
                                                 big.mark = " ", 
                                                 scientific = FALSE),
                     expand = c(0, 0)) +
  labs(title = "Wirtschaftliche Bevölkerung der Stadt Zürich",
       subtitle = "seit 1901",
       x = " ",
       y = "Anzahl Personen",
       caption = "Quelle: BVS, Statistik Stadt Zürich") +
  ssz_theme(grid_lines = "y",
            base_family = "HelveticaNeueLT Pro 55 Roman",
            base_size = 12) +
  theme(axis.title.y = element_text(
    margin = margin(t = 0, r = -43, b = 0, l = 0)
  ))

# Save Plot
ggsave(
  paste0(here(), "/plots/bar_chart.png"),
  plot,
  width = 10,
  height = 6
)
