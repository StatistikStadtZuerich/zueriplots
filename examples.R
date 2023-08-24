# SSZ Plots with ggplot2, zueritheme und zuericolors ---------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)


# Bar Charts --------------------------------------------------------------

# Simple Bar Chart
URL <- "https://data.stadt-zuerich.ch/dataset/bev_bestand_jahr_od3243/download/BEV324OD3243.csv"
df <- fread(URL, encoding = "UTF-8")
color <- get_zuericolors(palette = "qual6",
                         nth = 1)

options(scipen = 999)
ggplot(data = df,
       aes(x = StichtagDatJahr,
           y = AnzBestWir)) +
  geom_bar(stat = "identity",
           fill = color) +
  scale_x_continuous(limits = c(min(df$StichtagDatJahr) - 1, max(df$StichtagDatJahr) + 1),
                     breaks = seq(min(df$StichtagDatJahr), max(df$StichtagDatJahr), 10)) +
  # scale_y_continuous(expand = c(0, 0)) +
  labs(title = "Wirtschaftliche Bevölkerung der Stadt Zürich",
       subtitle = "seit 1901",
       x = " ",
       y = "Anzahl Personen",
       caption = "Quelle: BVS, Statistik Stadt Zürich") +
  ssz_theme(grid_lines = "y") +
  theme(axis.title.y = element_text(
    margin = margin(t = 0, r = -27, b = 0, l = 0)
  ))


# Simple Line Chart -------------------------------------------------------
options(scipen = 999)
ggplot(data = df,
       aes(x = StichtagDatJahr,
           y = AnzBestWir)) +
  geom_line(stat = "identity",
           color = color,
           linewidth = 1) +
  scale_x_continuous(limits = c(min(df$StichtagDatJahr) - 1, max(df$StichtagDatJahr) + 1),
                     breaks = seq(min(df$StichtagDatJahr), max(df$StichtagDatJahr), 10)) +
  scale_y_continuous(limits = c(0, max(df$AnzBestWir) + 30000),
                     breaks = seq(0, max(df$AnzBestWir) + 10000, 50000)) +
  labs(title = "Wirtschaftliche Bevölkerung der Stadt Zürich",
       subtitle = "seit 1901",
       x = " ",
       y = "Anzahl Personen",
       caption = "Quelle: BVS, Statistik Stadt Zürich") +
  ssz_theme(grid_lines = "y") +
  theme(axis.title.y = element_text(
    margin = margin(t = 0, r = -27, b = 0, l = 0)
  ))
  

# Simple Area Chart -------------------------------------------------------
URL <- "https://data.stadt-zuerich.ch/dataset/bev_bestand_jahr_herkunft_geschlecht_od3222/download/BEV322OD3222.csv"
df <- fread(URL, encoding = "UTF-8") %>% 
  group_by(StichtagDatJahr, HerkunftLang) %>% 
  summarise(AnzBestWir = sum(AnzBestWir))
colors <- get_zuericolors(palette = "qual6b",
                         nth = c(6, 5))

options(scipen = 999)
ggplot(data = df,
       aes(x = StichtagDatJahr,
           y = AnzBestWir,
           fill = HerkunftLang)) +
  geom_area(color = "white") +
  # scale_x_continuous(limits = c(min(df$StichtagDatJahr) - 1, max(df$StichtagDatJahr) + 1),
  #                    breaks = seq(min(df$StichtagDatJahr), max(df$StichtagDatJahr), 10)) +
  # scale_y_continuous(limits = c(0, max(df$AnzBestWir) + 55000),
  #                    breaks = seq(0, max(df$AnzBestWir) + 50000, 50000)) +
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

# Stacked Bar Chart with confidence intervalls
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
colors <- get_zuericolors(palette = "qual6",
                          nth = c(1, 4, 2))

ggplot(data = df,
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
  ssz_theme(grid_lines = "x")
