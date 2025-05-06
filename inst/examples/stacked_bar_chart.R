# SSZ stacked Bar Chart -----------------------------------------------------------

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
URL <- URL <- "https://data.stadt-zuerich.ch/dataset/bfs_bev_bildungsstand_seit1970_od1002/download/BIL100OD1002.csv"
df <- fread(URL, encoding = "UTF-8") %>% 
  filter(Jahr >= 2010) %>% 
  group_by(Jahr) %>% 
  mutate(AntCum = cumsum(AntBev),
         rang = seq(1:3)) %>% 
  ungroup() %>% 
  mutate(AntCumUn = AntCum - (AntBev - untAntBevKI),
         AntCumOb = AntCum + (obAntBevKI - AntBev),
         Jahr = as.factor(Jahr))

# Define Colors
colors <- get_zuericolors(palette = "qual6", nth = c(1, 4, 2))

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
       aes(x = AntBev,
           y = Jahr,
           fill = reorder(Bildungsstand, -rang))) +
  geom_bar(stat = "identity",
           width = 0.6) +
  geom_errorbar(aes(y = Jahr,
                    xmin = AntCumUn,
                    xmax = AntCumOb),
                width = 0.1,
                linewidth = 0.25,
                color = get_zuericolors(palette = "seq6gry",
                                        nth = 6)) +
  scale_fill_manual(values = colors) +
  scale_x_continuous(expand = c(0, 0)) +
  labs(title = "Bevölkerung nach Bildungsstand",
       subtitle = "seit 2010",
       x = "Anteil (in %)",
       y = "",
       caption = "Quelle: Strukturerhebung, Bundesamt für Statistik.\n95%-Konfidenzintervalle") +
  ssz_theme(grid_lines = "x",
            base_family = "Helv",
            base_size = 12)

# Save Plot
ggsave(
  here("plots", "stacked_bar_chart.png"),
  p,
  width = 10,
  height = 6
)
