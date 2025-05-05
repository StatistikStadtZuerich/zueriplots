# SSZ Ridgeline Chart -----------------------------------------------------------

# Required Libraries
library(data.table)
library(dplyr)
library(forcats)
library(ggplot2)
library(ggridges)
library(here)
library(lubridate)
library(rappdirs)
library(showtext)
library(viridis)
library(zuericolors)
library(zueritheme)

# Data
URL <- "https://data.stadt-zuerich.ch/dataset/ugz_meteodaten_tagesmittelwerte/download/ugz_ogd_meteo_d1_2021.csv"
df <- fread(URL, encoding = "UTF-8") %>%
  filter(Standort == "Zch_Stampfenbachstrasse" & Parameter == "T") %>%
  mutate(date = as.Date(Datum),
         month = fct_rev(lubridate::month(date, label = TRUE)))

# Define Colors
colors <- get_zuericolors(palette = "div9val", nth = c(9, 4, 3))

# Import HelveticaNeue LT Pro
path_to_font <- file.path(user_config_dir(roaming = FALSE, os = "win"), "Microsoft", "Windows", "Fonts")

font_add(family = "Helv",
         regular = file.path(path_to_font, "HelveticaNeueLTPro-Roman.ttf"),
         bold = file.path(path_to_font, "HelveticaNeueLTPro-Hv.ttf"))

# Plotting Resolution Parameters
showtext_auto()
showtext_opts(dpi = 300)

# Plot
p <- ggplot(data = df,
       aes(x = Wert,
           y = month,
           fill = after_stat(x))) +
  geom_density_ridges_gradient(scale = 3,
                               rel_min_height = 0.01,
                               color= "white") +
  scale_y_discrete(expand = c(0, 0)) +
  scale_fill_gradient2(low = colors[1],
                       mid = colors[2],
                       high = colors[3],
                       midpoint = 17,
                       breaks = c(-5, 5, 15, 25)) +
  labs(x = "Temperatur (in °C)",
       y = " ",
       title = "Tagesmittelwerte an der Stampfenbachstrasse",
       subtitle = "2021") +
  ssz_theme(grid_lines = "y",
            base_family = "Helv",
            base_size = 12)

# Save Plot
ggsave(
  here("plots", "ridgeline_chart.png"),
  p,
  width = 8,
  height = 6
)
