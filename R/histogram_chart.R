# SSZ Histogram Chart -----------------------------------------------------------

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
set.seed(1234)
df <- as.data.frame(rnorm(2000, 0, 10)) %>% 
  rename(wert = `rnorm(2000, 0, 10)`)

# Define Colors
color <- get_zuericolors(palette = "qual6", nth = 5)

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
       aes(x = wert)) +
  geom_histogram(binwidth = 1,
                 fill = color,
                 color = "white") +
  labs(title = "Histogram",
       subtitle = "Beispiel",
       x = " ",
       y = "Anzahl",) +
  scale_y_continuous(expand = c(0, 0)) +
  ssz_theme(grid_lines = "y",
            base_family = "Helv",
            base_size = 12) +
  theme(axis.title.y = element_text(
    margin = margin(t = 0, r = -13, b = 0, l = 0)
  ))

# Save Plot
ggsave(
  here("plots", "histogram_chart.png"),
  p,
  width = 10,
  height = 6
)
