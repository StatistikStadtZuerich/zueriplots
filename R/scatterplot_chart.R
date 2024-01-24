# SSZ Scatterplot Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(showtext)

# Define Colors
colors <- get_zuericolors(palette = "qual6", nth = c(4:6))

# Import HelveticaNeue LT Pro (Change path to where the font is)
font_add(family = "Helv", 
         regular = "C:/Path_to_the_Font/HelveticaNeueLTPro-Roman.ttf",
         bold = "C:/Path_to_the_Font/HelveticaNeueLTPro-Hv.ttf")

# Plotting Resolution Parameters
showtext_auto()
showtext_opts(dpi = 300)

# Plot
plot <- ggplot(data = iris,
       aes(x = Sepal.Length,
           y = Sepal.Width,
           color = Species)) +
  geom_point(size = 2) +
  scale_color_manual(values = colors) +
  scale_y_continuous(limits = c(1.5, 4.5)) +
  labs(title = "Scatterplot",
       subtitle = "Beispiel",
       x = "Sepal Length",
       y = "Sepal Width") +
  ssz_theme(grid_lines = "both",
            base_family = "Helv",
            base_size = 12) +
  theme(axis.title.y = element_text(
    margin = margin(t = 0, r = -3, b = 0, l = 0)
  ))

# Save Plot
ggsave(
  paste0(here(), "/plots/scatterplot_chart.png"),
  plot,
  width = 10,
  height = 6
)
