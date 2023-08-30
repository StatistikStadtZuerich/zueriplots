# SSZ Heatmap Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(extrafont)

# Data
x <- LETTERS[1:26]
y <- paste0("Variable ", seq(1,26))
df <- expand.grid(X = x,
                  Y = y)
df$Z <- runif(676, 0, 100)

# Define Colors
colors <- get_zuericolors(palette = "seq9red", nth = c(1, 9))

# Import HelveticaNeueLTPro
font_import(pattern = "HelveticaNeueLTPro-Roman.ttf")
loadfonts(device = "win")
windowsFonts()

# Plot
plot <- ggplot(data = df,
       aes(x = X,
           y = Y,
           fill = Z)) +
  geom_tile() +
  labs(x = " ",
       y = " ") +
  scale_fill_gradient(low = colors[1],
                      high = colors[2]) +
  labs(title = "Beispiel Heatmap",
       subtitle = "2023",
       caption = "Quelle: Fiktive Zahlen") +
  ssz_theme(grid_lines = "both",
            base_family = "HelveticaNeueLT Pro 55 Roman",
            base_size = 12)

# Save Plot
ggsave(
  paste0(here(), "/plots/heatmap_chart.png"),
  plot,
  width = 10,
  height = 9
)
