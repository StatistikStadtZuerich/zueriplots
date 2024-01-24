# SSZ Histogram Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(showtext)

# Data
set.seed(1234)
df <- as.data.frame(rnorm(2000, 0, 10)) %>% 
  rename(wert = `rnorm(2000, 0, 10)`)

# Define Colors
color <- get_zuericolors(palette = "qual6", nth = 5)

# Import HelveticaNeue LT Pro (Change path to where the font is)
font_add(family = "Helv", 
         regular = "C:/Path_to_the_Font/HelveticaNeueLTPro-Roman.ttf",
         bold = "C:/Path_to_the_Font/HelveticaNeueLTPro-Hv.ttf")

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
