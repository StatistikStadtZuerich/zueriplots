# SSZ Area Chart -----------------------------------------------------------

# Required Libraries
library(data.table)
library(dplyr)
library(here)
library(ggplot2)
library(rappdirs)
library(showtext)
library(zuericolors)
library(zueritheme)

# Data
URL <- "https://data.stadt-zuerich.ch/dataset/bev_bestand_jahr_herkunft_geschlecht_od3222/download/BEV322OD3222.csv"
df <- fread(URL, encoding = "UTF-8") %>%
  group_by(StichtagDatJahr, HerkunftLang) %>%
  summarise(AnzBestWir = sum(AnzBestWir))

# Define Colors
colors <- get_zuericolors(palette = "qual6b", nth = c(6, 5))

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
       aes(x = StichtagDatJahr,
           y = AnzBestWir,
           fill = HerkunftLang)) +
  geom_area(color = "white") +
  scale_fill_manual(values = colors) +
  scale_y_continuous(labels = function(x) format(x,
                                                 big.mark = " ",
                                                 scientific = FALSE),
                     limits = c(0, 500000),
                     breaks = seq(0, 450000, 50000)) +
  scale_x_continuous(expand = c(0, 0),
                     limits = c(min(df$StichtagDatJahr) - 1, max(df$StichtagDatJahr) + 1),
                     breaks = seq(min(df$StichtagDatJahr) - 1, max(df$StichtagDatJahr) + 1, 20)) +
  labs(title = "Wirtschaftliche Bevölkerung der Stadt Zürich",
       subtitle = "nach Herkunft, seit 1901",
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
  here("man", "figures", "area_chart.png"),
  p,
  width = 10,
  height = 6
)
