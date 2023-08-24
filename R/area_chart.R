# SSZ Area Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)

# Data
URL <- URL <- "https://data.stadt-zuerich.ch/dataset/bev_bestand_jahr_herkunft_geschlecht_od3222/download/BEV322OD3222.csv"
df <- fread(URL, encoding = "UTF-8") %>% 
  group_by(StichtagDatJahr, HerkunftLang) %>% 
  summarise(AnzBestWir = sum(AnzBestWir))

# Define Colors
colors <- get_zuericolors(palette = "qual6b", nth = c(6, 5))

# Plot
options(scipen = 999)
plot <- ggplot(data = df,
       aes(x = StichtagDatJahr,
           y = AnzBestWir,
           fill = HerkunftLang)) +
  geom_area(color = "white") +
  scale_fill_manual(values = colors) +
  labs(title = "Wirtschaftliche Bevölkerung der Stadt Zürich",
       subtitle = "nach Herkunft, seit 1901",
       x = " ",
       y = "Anzahl Personen",
       caption = "Quelle: BVS, Statistik Stadt Zürich") +
  ssz_theme(grid_lines = "y") +
  theme(axis.title.y = element_text(
    margin = margin(t = 0, r = -27, b = 0, l = 0)
  ))

# Save Plot
ggsave(
  paste0(here(), "/plots/area_chart.png"),
  plot,
  width = 10,
  height = 6
)