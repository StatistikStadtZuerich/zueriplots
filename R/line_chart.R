# SSZ Line Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(showtext)

# Data
URL <- "https://data.stadt-zuerich.ch/dataset/bev_bestand_jahr_od3243/download/BEV324OD3243.csv"
df <- fread(URL, encoding = "UTF-8")

# Define Colors
color <- get_zuericolors(palette = "qual6", nth = 1)

# Import HelveticaNeue LT Pro (Change path to where the font is)
font_add(family = "Helv", 
         regular = "C:/Path_to_the_Font/HelveticaNeueLTPro-Roman.ttf",
         bold = "C:/Path_to_the_Font/HelveticaNeueLTPro-Hv.ttf")

# Plotting Resolution Parameters
showtext_auto()
showtext_opts(dpi = 300)

# Plot
plot <- ggplot(data = df,
       aes(x = StichtagDatJahr,
           y = AnzBestWir)) +
  geom_line(stat = "identity",
            color = get_zuericolors(palette = "qual6", nth = 1),
            linewidth = 1) +
  scale_y_continuous(labels = function(x) format(x, 
                                                 big.mark = " ", 
                                                 scientific = FALSE),
                     limits = c(0, 500000),
                     breaks = seq(0, 450000, 50000)) +
  scale_x_continuous(expand = c(0, 0),
                     limits = c(min(df$StichtagDatJahr) - 1, max(df$StichtagDatJahr) + 1),
                     breaks = seq(min(df$StichtagDatJahr) - 1, max(df$StichtagDatJahr) + 1, 20)) +
  labs(title = "Wirtschaftliche Bevölkerung der Stadt Zürich",
       subtitle = "seit 1901",
       x = " ",
       y = "Anzahl Personen",
       caption = "Quelle: BVS, Statistik Stadt Zürich") +
  ssz_theme(grid_lines = "y",
            base_family = "Helv",
            base_size = 12) +
  theme(axis.title.y = element_text(
    margin = margin(t = 0, r = -43, b = 0, l = 0)
  ))

# Save Plot
ggsave(
  paste0(here(), "/plots/line_chart.png"),
  plot,
  width = 10,
  height = 6
)
