library(dplyr)
library(jsonlite)
library(mapgl)
library(sf)
library(zuericolors)

# prepare parameters: colors
zueriblau <- get_zuericolors("qual6", 1)
hover_color <- get_zuericolors("qual6a", 2)
outline_color <- get_zuericolors("seq6gry", 5)
background_color <- get_zuericolors("seq6gry", 1)
cluster_colors <- get_zuericolors("qual6b", 6:4)

# read Stadtkreise from OGD portal
stadtkreise <- read_sf("https://www.ogd.stadt-zuerich.ch/wfs/geoportal/Stadtkreise?service=WFS&version=1.1.0&request=GetFeature&outputFormat=application/json&typename=adm_stadtkreise_a")

# based on stadtkreise, get border of the city to be used as a mask later
# st_union only seems to work with a bit of weird wrangling with sf
sf_use_s2(FALSE)
bbox <- st_as_sfc(st_bbox(c(xmin = 5, xmax = 15, ymin = 44, ymax = 50), crs = 4326))
stadtgrenze <- stadtkreise |>
  st_make_valid() |>
  st_transform(2056) |>
  st_union() |>
  st_transform(4326)
neg_stadtgrenze <- st_difference(bbox, stadtgrenze)
bbox_stadt <- st_bbox(stadtgrenze)
buffer <- 0.05
sf_use_s2(TRUE)

# get example geo data to plot on the map: locations where the number of cars
# are counted (MIV-Zählstellen)
link_geojson <- "https://www.ogd.stadt-zuerich.ch/wfs/geoportal/Standorte_der_Verkehrszaehlungen_MIV?service=WFS&version=1.1.0&request=GetFeature&outputFormat=application/json&typename=tbl_standort_zaehlung_miv_p"
df_loc <- st_read(link_geojson) |>
  # keep only the ones that are currently still counting
  filter(status == "aktiv") |>
  # create HTML tooltip (can be styled with the CSS classes we add)
  mutate(
    tooltip = glue(
      "<div class='tooltip-container'>
            <div class='tooltip-title'>
              Zählstelle (ID)
            </div>
            <hr>
            <div class='tooltip-content'>
              <div class='tooltip-row'>
                  <span class='tooltip-value'>{zsname} ({zsid})</span>
              </div>
            </div>
        </div>"
    )
  )

# prepare tiles for map (in color)
wms_base <- "https://www.ogd.stadt-zuerich.ch/mapproxy/service?"

wms_tile_template <- paste0(
  wms_base,
  "SERVICE=WMS",
  "&REQUEST=GetMap",
  "&VERSION=1.1.1",
  "&LAYERS=Basiskarte_Zuerich_Raster",
  "&STYLES=",
  "&FORMAT=image/png",
  "&TRANSPARENT=FALSE",
  "&SRS=EPSG:3857",
  "&BBOX={bbox-epsg-3857}",
  "&WIDTH=256",
  "&HEIGHT=256"
)

# for a grey base map, use the following code
# wms_base <- "https://www.ogc.stadt-zuerich.ch/mapproxy/service?"
#
# wms_tile_template <- paste0(
#   wms_base,
#   "SERVICE=WMS",
#   "&REQUEST=GetMap",
#   "&VERSION=1.1.1",
#   "&LAYERS=basiskarte_zuerich_grau",
#   "&STYLES=",
#   "&FORMAT=image/png",
#   "&TRANSPARENT=FALSE",
#   "&SRS=EPSG:3857",
#   "&BBOX={bbox-epsg-3857}",
#   "&WIDTH=256",
#   "&HEIGHT=256"
# )


# prepare empty style to start with empty map (sources must be {} not [])
empty_style <- jsonlite::fromJSON(
  '{
    "version": 8,
    "sources": {},
    "layers": [
      { "id": "background", "type": "background",
        "paint": { "background-color": "#ffffff" } }
    ]
  }',
  simplifyVector = FALSE
)

# create map
maplibre(
  style = empty_style,
  center = c(8.5417, 47.3769),
  zoom = 11,
  minZoom = 10,
  maxZoom = 22,
  maxBounds = list(
    c(bbox_stadt[["xmin"]] - buffer, bbox_stadt[["ymin"]] - buffer),
    c(bbox_stadt[["xmax"]] + buffer, bbox_stadt[["ymax"]] + buffer)
  )
) |>
  add_raster_source(
    id = "zh_basemap",
    tiles = wms_tile_template,
    tileSize = 256,
    maxZoom = 22
  ) |>
  add_raster_layer(
    id = "zh_basemap_layer",
    source = "zh_basemap",
    raster_opacity = 0.8
  ) |>
  add_source(
    id = "mask",
    data = st_sf(neg_stadtgrenze)
  ) |>
  add_fill_layer(
    id = "mask-fill",
    source = "mask",
    fill_color = background_color,
    fill_opacity = 1,
    fill_outline_color = outline_color,
  ) |>
  add_circle_layer(
    id = "locations",
    source = df_loc,
    circle_color = zueriblau,
    circle_radius = 10,
    circle_opacity = 0.9,
    tooltip = "tooltip",
    hover_options = list(
      circle_radius = 12,
      circle_color = hover_color
    ),
    cluster_options = cluster_options(
      max_zoom = 15,
      color_stops = cluster_colors,
      text_color = "black"
    )
  ) |>
  add_scale_control() |>
  add_navigation_control(show_compass = FALSE)
