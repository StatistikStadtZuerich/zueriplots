# SSZ Ridgeline Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(showtext)
library(viridis)
library(ggridges)
library(lubridate)
library(forcats)
library(rappdirs)

# Data
URL <- "https://data.stadt-zuerich.ch/dataset/ugz_meteodaten_tagesmittelwerte/download/ugz_ogd_meteo_d1_2021.csv"
df <- fread(URL, encoding = "UTF-8") %>% 
  filter(Standort == "Zch_Stampfenbachstrasse" & Parameter == "T") %>% 
  mutate(date = as.Date(Datum),
         month = fct_rev(month(date, label = TRUE)))

# Define Colors
colors <- get_zuericolors(palette = "div9val", nth = c(9, 4, 3))

# Import HelveticaNeue LT Pro
path_to_font <- paste0(user_config_dir(roaming = FALSE, os = "win"), "\\Microsoft\\Windows\\Fonts\\")

font_add(family = "Helv", 
         regular = paste0(path_to_font, "HelveticaNeueLTPro-Roman.ttf"),
         bold = paste0(path_to_font, "HelveticaNeueLTPro-HV_0.ttf"))

# Plotting Resolution Parameters
showtext_auto()
showtext_opts(dpi = 300)

# Plot
plot <- ggplot(data = df,
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
  paste0(here(), "/plots/ridgeline_chart.png"),
  plot,
  width = 8,
  height = 6
)
