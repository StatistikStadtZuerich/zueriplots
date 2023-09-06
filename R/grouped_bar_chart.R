# SSZ Grouped Bar Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(extrafont)

# Data
URL <- "https://data.stadt-zuerich.ch/dataset/bfs_bev_bildungsstand_seit1970_od1002/download/BIL100OD1002.csv"
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

# Import HelveticaNeueLTPro
font_import(pattern = "HelveticaNeueLTPro-Roman.ttf")
loadfonts(device = "win")
windowsFonts()

# Plot
plot <- ggplot(data = df,
       aes(x = Jahr,
           y = AntBev,
           fill = reorder(Bildungsstand, -rang))) +
  geom_bar(stat = "identity",
           position = position_dodge(width = 0.7),
           width = 0.6) +
  geom_errorbar(aes(x = Jahr,
                    ymin = untAntBevKI,
                    ymax = obAntBevKI),
                width = 0.1,
                linewidth = 0.25,
                position = position_dodge(width = 0.7),
                color = get_zuericolors(palette = "seq6gry",
                                        nth = 6)) +
  scale_fill_manual(values = colors) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(title = "Bevölkerung nach Bildungsstand",
       subtitle = "seit 2010",
       x = " ",
       y = "Anteil (in %)",
       caption = "Quelle: Strukturerhebung, Bundesamt für Statistik.\n95%-Konfidenzintervalle") +
  ssz_theme(grid_lines = "y",
            base_family = "HelveticaNeueLT Pro 55 Roman",
            base_size = 12) +
  theme(axis.title.y = element_text(
    margin = margin(t = 0, r = -13, b = 0, l = 0)
  ))

# Save Plot
ggsave(
  paste0(here(), "/plots/grouped_bar_chart.png"),
  plot,
  width = 12,
  height = 7
)