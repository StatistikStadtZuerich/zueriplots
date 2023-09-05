# SSZ Ridgeline Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(extrafont)
library(sf)
library(httr)
library(broom)

# Data
URL <- "https://data.stadt-zuerich.ch/dataset/bev_bestand_jahr_bevoelkerungsdichten_flaechen_od5802/download/BEV580OD5802.csv"
data <- fread(URL, encoding = "UTF-8") %>% 
  filter(StichtagDatJahr == 2022 & RaumKategorie == "Stadtkreis") %>% 
  select(RaumSort, RaumLang, DichteT) %>% 
  rename(kname = RaumLang)

# Shape File
URL_geojson <- "https://www.ogd.stadt-zuerich.ch/wfs/geoportal/Stadtkreise?service=WFS&version=1.1.0&request=GetFeature&outputFormat=GeoJSON&typename=adm_stadtkreise_v"
quartiere <- st_read(URL_geojson)

# Combine Shape File Data with other Data
df <- quartiere %>% 
  left_join(data, by = "kname")

# Define Colors
colors <- get_zuericolors(palette = "seq9blu", nth = c(1, 9))

# Import HelveticaNeueLTPro
font_import(pattern = "HelveticaNeueLTPro-Roman.ttf")
loadfonts(device = "win")
windowsFonts()

# Plot
plot <- ggplot() +
  geom_sf(data = df,
          aes(fill = DichteT),
          color = "white",
          linewidth = 0.75) +
  scale_fill_gradient(low = colors[1],
                      high = colors[2],
                      name = "Personen pro ha") +
  labs(title = "Bevölkerungsdichte in der Stadt Zürich",
       subtitle = "nach Stadtkreis (mit Bezug Gesamtfläche), 2022") +
  ssz_theme_void(base_family = "HelveticaNeueLT Pro 55 Roman",
                 base_size = 12) +
  theme(legend.title = element_text(
    color = "#020304",
    size = rel(1),
    face = "bold"
  ))

# Save Plot
ggsave(
  paste0(here(), "/plots/map_chart.png"),
  plot,
  width = 10,
  height = 6
)
