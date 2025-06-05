# SSZ Map: Heatmap Chart -----------------------------------------------------------

# Required Libraries
library(data.table)
library(dplyr)
library(here)
library(ggpattern)
library(ggplot2)
library(rappdirs)
library(sf)
library(showtext)
library(zuericolors)
library(zueritheme)

# A note on coordinates: as the density algorithm fails with the original coordinates, where all the
# differences lie in some small decimal, convert all geometric data

# Data
URL <- "https://www.ogd.stadt-zuerich.ch/wfs/geoportal/Baumkataster?service=WFS&version=1.1.0&request=GetFeature&outputFormat=GeoJSON&typename=baumkataster_baumstandorte"
data <- st_read(URL) |>
  st_transform(crs = 2056)

# Shape files for background
URL_geojson <- "https://raw.githubusercontent.com/StatistikStadtZuerich/sszvis/master/geodata/stadtkreise.json"
quartiere <- st_read(URL_geojson) |>
  st_transform(crs = 2056)

URL_geojson_see <- "https://raw.githubusercontent.com/StatistikStadtZuerich/sszvis/master/geodata/lakezurich.geojson"
see <- st_read(URL_geojson_see) |>
  st_transform(crs = 2056)

# Define Colors
colors_see <- get_zuericolors(palette = "seq6gry", nth = c(1, 2))
# Extract specific colors from the "qual12" palette
colors_heat <- c(get_zuericolors(palette = "qual12", nth = 4),
                 get_zuericolors(palette = "qual12br", nth = c(7, 12)))
# Create a color palette with `num_bins` colors using colorRampPalette
num_bins <- 10
colors_heat_extended <- colorRampPalette(colors_heat)(num_bins)

# Import HelveticaNeue LT Pro
path_to_font <- file.path(user_config_dir(roaming = FALSE, os = "win"), "Microsoft", "Windows", "Fonts")

font_add(family = "Helv",
         regular = file.path(path_to_font, "HelveticaNeueLTPro-Roman.ttf"),
         bold = file.path(path_to_font, "HelveticaNeueLTPro-Hv.ttf"))

# Plotting Resolution Parameters
showtext_auto()
showtext_opts(dpi = 300)

#' get_density
#'
#' Function to calculate the density of points/items with coordinates
#'
#' @param current_data data as read from csv, containing EKoord_raster, NKoord_raster and "Suffix" as columns
#' @param Suffix column with numeric data on number of items at a given coordinate
#'
#' @return density
get_density <- function(current_data, Suffix, n = 500, h = 500) {

  coords_in_data <- current_data |>
    st_as_sf(coords = c("X", "Y"), crs = 2056)

  # create a df with one row per observation
  df_single <- current_data |>
    tidyr::uncount(.data[[Suffix]])

  stopifnot(sum(coords_in_data |> pull(.data[[Suffix]]) |> sum()) == nrow(df_single))

  # Density berechnen
  d <- MASS::kde2d(df_single$X, df_single$Y,
                   n = n,
                   h = n)
  dens <- data.frame(expand.grid(x = d$x, y = d$y), z = as.vector(d$z))

  # normalise z values so that sum equals 1 / 100%
  dens <- dens |>
    mutate(z_scaled = z / sum(z) * 100)

  return(dens)
}

# prepare data for plotting: extract the coordinates
coords_extracted <- data |>
  st_coordinates() |>
  as.data.frame()

# join back to data
df <- bind_cols(data, coords_extracted)

# calculate density
dens <- df |>
  mutate(anzahl = 1) |>
  get_density("anzahl")

# plot
p <- ggplot() +
  geom_sf(
    data = quartiere,
    fill = "transparent",
    color = "lightgrey",
    linewidth = 0.5
  ) +
  geom_sf_pattern(data = see,
                  color = NA,
                  fill = colors_see[1],
                  pattern_fill = colors_see[2],
                  pattern_color = colors_see[2],
                  pattern_angle = 45,
                  pattern_density = 0.07,
                  pattern_spacing = 0.01) +
  geom_contour_filled(data = dens,
                      aes(x = x, y = y, z = z_scaled,
                          alpha = after_stat(level)),
                      bins = num_bins) +
  coord_sf() +
  scale_alpha_manual(values = c(0, rep(0.85, 14)), guide = "none") +
  scale_fill_manual(values = colors_heat_extended) +
  ssz_theme_void(base_family = "Helv", base_size = 12) +
  theme(legend.position = "none",
        legend.title = element_text(color = "#020304")) +
  labs(title = "Baumdichte in der Stadt Zürich",
       subtitle = "basierend auf dem Baumkataster, ohne Wald") +
  theme(legend.title = element_text(
    color = "#020304",
    size = rel(1),
    face = "bold"
  ))

# Save Plot
ggsave(
  here("man", "figures", "map_heatmap.png"),
  p,
  width = 8,
  height = 6
)
