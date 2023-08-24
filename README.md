# zueriplots

The goal of zueriplots is to provide minimal code examples for ggplot graphs that conforms - together with [zueritheme](https://github.com/StatistikStadtZuerich/zueritheme) and [zuericolors](https://github.com/StatistikStadtZuerich/zuericolors) - to the corporate identity/design of the city of Zurich.

## Example

This is an example which shows you how to build a graph that conforms to the corporate design of the city of Zurich. First you must install zuericolors and zueritheme from GitHub.

``` r
# Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)

# Data
URL <- "https://data.stadt-zuerich.ch/dataset/bev_bestand_jahr_od3243/download/BEV324OD3243.csv"
df <- fread(URL, encoding = "UTF-8")

# Plot
options(scipen = 999)
plot <- ggplot(data = df,
       aes(x = StichtagDatJahr,
           y = AnzBestWir)) +
  geom_line(stat = "identity",
            color = get_zuericolors(palette = "qual6", nth = 1),
            linewidth = 1) +
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
```

<img src='plots/line_chart.png' />