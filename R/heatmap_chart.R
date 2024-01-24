# SSZ Heatmap Chart -----------------------------------------------------------

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
x <- LETTERS[1:26]
y <- paste0("Variable ", seq(1,26))
df <- expand.grid(X = x,
                  Y = y)
df$Z <- runif(676, 0, 100)

# Define Colors
colors <- get_zuericolors(palette = "seq9red", nth = c(1, 9))

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
