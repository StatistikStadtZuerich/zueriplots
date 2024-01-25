# SSZ Doughnut Chart -----------------------------------------------------------

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
df <- data.frame(kat = c("A", "B", "C"),
                 wert = c(10, 60, 30))
df$fraction <- df$wert / sum(df$wert)
df$ymax <- cumsum(df$fraction)
df$ymin <- c(0, head(df$ymax, n = -1))
df$labelPosition <- (df$ymax + df$ymin) / 2
df$label <- paste0(df$wert, " %")

# Define Colors
colors <- get_zuericolors(palette = "qual6", nth = c(3:6))

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
            color = "white",
            family = "Helv") +
  scale_fill_manual(values = colors) +
  labs(title = "Anteile einer erfundenen Verteilung",
       subtitle = "2023",
       caption = "Quelle: Fiktive Zahlen") +
  xlim(c(2, 4)) +
  coord_polar(theta="y") +
  ssz_theme_void(base_family = "Helv",
                 base_size = 12)

# Save Plot
ggsave(
  here("plots", "doughnut_chart.png"),
  p,
  width = 6,
  height = 5
)
