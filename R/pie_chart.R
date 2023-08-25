# SSZ Pie Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(ggpubr)

# Data
df <- data.frame(kat =c ("A", "B", "C"),
                 wert = c(10, 60, 30))
df$fraction <- df$wert / sum(df$wert)
df$ymax <- cumsum(df$fraction)
df$ymin <- c(0, head(df$ymax, n = -1))
df$labelPosition <- (df$ymax + df$ymin) / 2
df$label <- paste0(df$wert, " %")

# Define Colors
colors <- get_zuericolors(palette = "qual6", nth = c(3:6))

# Import HelveticaNeueLTPro
font_import(pattern = "HelveticaNeueLTPro-Roman.ttf")
loadfonts(device = "win")
windowsFonts()

# Plot
plot <- ggplot(data = df,
       aes(ymax = ymax,
           ymin = ymin,
           fill = kat,
           xmin = 4,
           xmax = 3)) +
  geom_rect(color = "white",
            linewidth = 1) +
  geom_text(x = 3.5,
            aes(y = labelPosition,
                label = label),
            size = 3.5,
            color = "white") +
  scale_fill_manual(values = colors) +
  coord_polar(theta="y") +
  ssz_theme_void(base_family = "HelveticaNeueLT Pro 55 Roman",
                 base_size = 12) +
  theme(panel.background = element_rect(fill = "white"))

# Save Plot
ggsave(
  paste0(here(), "/plots/pie_chart.png"),
  plot,
  width = 6,
  height = 6
)
