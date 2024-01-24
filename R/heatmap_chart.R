# SSZ Heatmap Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(showtext)

# Data
x <- LETTERS[1:26]
y <- paste0("Variable ", seq(1,26))
df <- expand.grid(X = x,
                  Y = y)
df$Z <- runif(676, 0, 100)

# Define Colors
colors <- get_zuericolors(palette = "seq9red", nth = c(1, 9))

# Import HelveticaNeue LT Pro (Change path to where the font is)
font_add(family = "Helv", 
         regular = "C:/Path_to_the_Font/HelveticaNeueLTPro-Roman.ttf",
         bold = "C:/Path_to_the_Font/HelveticaNeueLTPro-Hv.ttf")

# Plotting Resolution Parameters
showtext_auto()
showtext_opts(dpi = 300)

# Plot
plot <- ggplot(data = df,
       aes(x = X,
           y = Y,
           fill = Z)) +
  geom_tile() +
  labs(x = " ",
       y = " ") +
  scale_fill_gradient(low = colors[1],
                      high = colors[2],
                      breaks = seq(10, 100, 20)) +
  labs(title = "Beispiel Heatmap",
       subtitle = "2023",
       caption = "Quelle: Fiktive Zahlen") +
  ssz_theme(grid_lines = "both",
            base_family = "Helv",
            base_size = 12)

# Save Plot
ggsave(
  paste0(here(), "/plots/heatmap_chart.png"),
  plot,
  width = 10,
  height = 9
)
