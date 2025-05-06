# SSZ Boxplot Chart -----------------------------------------------------------

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
df <- data.frame(kat = c(rep("A", 500),
                         rep("B", 500),
                         rep("B", 500),
                         rep("C", 20),
                         rep("D", 100)),
                 wert = c(rnorm(500, 10, 5),
                          rnorm(500, 13, 1),
                          rnorm(500, 18, 1),
                          rnorm(20, 25, 4),
                          rnorm(100, 12, 1)))

# Define Colors
colors <- get_zuericolors(palette = "qual6", nth = 1:4)

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
               aes(x = kat,
                   y = wert,
                   fill = kat)) +
  geom_boxplot(alpha = 0.75) +
  scale_fill_manual(values = colors) +
  geom_jitter(color = get_zuericolors(palette = "seq6gry", nth = 6),
              size = 0.75,
              alpha = 0.25) +
  scale_y_continuous(limits = c(-5, 32)) +
  labs(title = "Boxplot",
       subtitle = "Beispiel",
       x = " ",
       y = "Verteilung") +
  ssz_theme(grid_lines = "y",
            base_family = "Helv",
            base_size = 12) +
  theme(axis.title.y = element_text(
    margin = margin(t = 0, r = -13, b = 0, l = 0)
  ))

# Save Plot
ggsave(
  here("plots", "boxplot_chart.png"),
  p,
  width = 10,
  height = 6
)
