# SSZ Map: hexbin Chart -----------------------------------------------------------

# Required Libraries
library(data.table)
library(dplyr)
library(here)
library(ggpattern)
library(ggplot2)
library(hexbin)
library(rappdirs)
library(sf)
library(showtext)
library(zuericolors)
library(zueritheme)

# Data
URL <- "https://www.ogd.stadt-zuerich.ch/wfs/geoportal/Baumkataster?service=WFS&version=1.1.0&request=GetFeature&outputFormat=GeoJSON&typename=baumkataster_baumstandorte"
data <- st_read(URL)

# Shape files for background
URL_geojson <- "https://raw.githubusercontent.com/StatistikStadtZuerich/sszvis/master/geodata/stadtkreise.json"
quartiere <- st_read(URL_geojson)

URL_geojson_see <- "https://raw.githubusercontent.com/StatistikStadtZuerich/sszvis/master/geodata/lakezurich.geojson"
see <- st_read(URL_geojson_see)

# Define Colors
colors_see <- get_zuericolors(palette = "seq6gry", nth = c(1, 2))
# define appropriate color scale (choose any of the zuericolors sequential palettes)
colors_map <- get_zuericolors(palette = "seq9grn", nth = c(1, 3, 5, 7, 9))

# Import HelveticaNeue LT Pro
path_to_font <- file.path(user_config_dir(roaming = FALSE, os = "win"), "Microsoft", "Windows", "Fonts")

font_add(family = "Helv",
         regular = file.path(path_to_font, "HelveticaNeueLTPro-Roman.ttf"),
         bold = file.path(path_to_font, "HelveticaNeueLTPro-Hv.ttf"))

# Plotting Resolution Parameters
showtext_auto()
showtext_opts(dpi = 300)

# prepare data for plotting: extract coordinates
coords_extracted <- data |>
  st_coordinates() |>
  as.data.frame()

# join back to data
df <- bind_cols(data, coords_extracted)

# create a df with one row per observation; here, this is already the case, but
# included as this is crucial for correct density
df_single <- df |>
  mutate(anzahl = 1) |>
  tidyr::uncount(.data[["anzahl"]])

# Define parameters for graph
n_bins <- 30

# Plot
p <-   ggplot() +
  # Plot hexbin for the points in 'ha_single'
  stat_bin_hex(
    data = df_single,
    aes(x = X, y = Y),
    alpha = 0.8,
    geom = "hex",
    bins = n_bins
  ) +
  # Quartiere borders and background
  geom_sf(
    data = quartiere,
    fill = "transparent",
    color = colors_map[3],
    linewidth = 0.25
  ) +
  # Add pattern fill for 'see' areas
  geom_sf_pattern(
    data = see,
    color = "white",
    fill = colors_see[1],
    pattern_fill = colors_see[2],
    pattern_color = colors_see[2],
    pattern_angle = 45,
    pattern_density = 0.07,
    pattern_spacing = 0.01
  ) +
  coord_sf() +
  # Apply custom color scale
  scale_fill_gradientn(colors = colors_map) +
  # Apply custom theme
  ssz_theme_void(base_size = 12,
                 base_family = "Helv") +
  labs(title = "Baumdichte nach Baumkataster",
       subtitle = "ohne Wald",
       fill = "")

# Save Plot
ggsave(
  here("man", "figures", "map_hexbin.png"),
  p,
  width = 8,
  height = 6
)
