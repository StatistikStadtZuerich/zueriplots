# SSZ Bar Chart -----------------------------------------------------------

# Required Libraries
library(data.table)
library(dplyr)
library(ggplot2)
library(here)
library(rappdirs)
library(showtext)
library(zuericolors)
library(zueritheme)

# Data
URL <- "https://data.stadt-zuerich.ch/dataset/bev_bestand_jahr_od3243/download/BEV324OD3243.csv"
df <- fread(URL, encoding = "UTF-8")

# Define Colors
color <- get_zuericolors(palette = "qual6", nth = 1)

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
       aes(x = StichtagDatJahr,
           y = AnzBestWir)) +
  geom_bar(stat = "identity",
           fill = color,
           width = 0.7) +
  scale_y_continuous(labels = function(x) format(x, 
                                                 big.mark = " ", 
                                                 scientific = FALSE)) +
  scale_x_continuous(expand = c(0, 0),
                     limits = c(min(df$StichtagDatJahr) - 1, max(df$StichtagDatJahr) + 1),
                     breaks = seq(min(df$StichtagDatJahr) - 1, max(df$StichtagDatJahr) + 1, 20)) +
  labs(title = "Wirtschaftliche Bevölkerung der Stadt Zürich",
       subtitle = "seit 1901",
       x = " ",
       y = "Anzahl Personen",
       caption = "Quelle: BVS, Statistik Stadt Zürich") +
  ssz_theme(grid_lines = "y",
            base_size = 12,
            base_family = "Helv") +
  theme(axis.title.y = element_text(
    margin = margin(t = 0, r = -43, b = 0, l = 0)
  ))

# Save Plot
ggsave(
  here("plots", "bar_chart.png"),
  p,
  width = 10,
  height = 6
)
