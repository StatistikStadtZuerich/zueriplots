# SSZ Scatterplot Chart -----------------------------------------------------------

# Required Libraries
library(data.table)
library(dplyr)
library(ggplot2)
library(here)
library(rappdirs)
library(showtext)
library(zuericolors)
library(zueritheme)

# Define Colors
colors <- get_zuericolors(palette = "qual6", nth = c(4:6))

# Import HelveticaNeue LT Pro
path_to_font <- file.path(user_config_dir(roaming = FALSE, os = "win"), "Microsoft", "Windows", "Fonts")

font_add(family = "Helv", 
         regular = file.path(path_to_font, "HelveticaNeueLTPro-Roman.ttf"),
         bold = file.path(path_to_font, "HelveticaNeueLTPro-Hv.ttf"))

# Plotting Resolution Parameters
showtext_auto()
showtext_opts(dpi = 300)

# Plot
p <- ggplot(data = iris,
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
  here("plots", "scatterplot_chart.png"),
  p,
  width = 10,
  height = 6
)
