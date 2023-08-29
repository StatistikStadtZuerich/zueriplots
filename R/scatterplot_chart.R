# SSZ Scatterplot Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(extrafont)

# Define Colors
colors <- get_zuericolors(palette = "qual6", nth = c(4:6))

# Import HelveticaNeueLTPro
font_import(pattern = "HelveticaNeueLTPro-Roman.ttf")
loadfonts(device = "win")
windowsFonts()

# Plot
plot <- ggplot(data = iris,
       aes(x = Sepal.Length,
           y = Sepal.Width,
           color = Species)) +
  geom_point(size = 2) +
  scale_color_manual(values = colors) +
  scale_y_continuous(limits = c(1, 4.5)) +
  labs(title = "Scatterplot",
       subtitle = "Beispiel",
       x = "Sepal Length",
       y = "Sepal Width") +
  ssz_theme(grid_lines = "both",
            base_family = "HelveticaNeueLT Pro 55 Roman",
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