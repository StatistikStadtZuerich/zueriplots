# SSZ Histogram Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(showtext)
library(rappdirs)

# Data
set.seed(1234)
df <- as.data.frame(rnorm(2000, 0, 10)) %>% 
  rename(wert = `rnorm(2000, 0, 10)`)

# Define Colors
color <- get_zuericolors(palette = "qual6", nth = 5)

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
  paste0(here(), "/plots/histogram_chart.png"),
  plot,
  width = 10,
  height = 6
)
