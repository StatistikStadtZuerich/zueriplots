# SSZ Heatmap Chart -----------------------------------------------------------

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
x <- LETTERS[1:26]
y <- paste0("Variable ", seq(1,26))
df <- expand.grid(X = x,
                  Y = y)
df$Z <- runif(676, 0, 100)

# Define Colors
colors <- get_zuericolors(palette = "seq9red", nth = c(1, 9))

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
  here("plots", "heatmap_chart.png"),
  p,
  width = 10,
  height = 9
)
