library(dplyr)
library(glue)
library(htmltools)
library(leaflet)
library(sf)
library(zuericolors)

zueriblau <- get_zuericolors("qual6", 1)

# read Stadtkreise from OGD portal
stadtkreise <- read_sf("https://www.ogd.stadt-zuerich.ch/wfs/geoportal/Stadtkreise?service=WFS&version=1.1.0&request=GetFeature&outputFormat=application/json&typename=adm_stadtkreise_a")

# based on stadtkreise, get border of the city to be used as a mask later
# st_union only seems to work with a bit of weird wrangling with sf , and leaflet
# needs lon-lat projection
sf_use_s2(FALSE)
# Large bounding box (world or just a big area around Zurich)
bbox <- st_as_sfc(st_bbox(c(xmin = 5, xmax = 15, ymin = 44, ymax = 50), crs = 4326))
stadtgrenze <- stadtkreise |>
  st_make_valid() |>
  st_transform(2056) |> # otherwise (and with s2 active) st_union fails
  st_union() |>
  st_transform(4326) # leaflet needs longitude-latitude
# create a mask for the city with the big box and stadtgrenze
neg_stadtgrenze <- st_difference(bbox, stadtgrenze)
bbox_stadt <- st_bbox(stadtgrenze)
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

# create leaflet map
leaflet() |>
  # add tiles for background map: use city of Zurich's base map grey
  addWMSTiles(
    baseUrl = "https://www.ogc.stadt-zuerich.ch/mapproxy/service?",
    layers = "basiskarte_zuerich_grau",
    attribution = "GeoZ",
    options = WMSTileOptions(
      format = "image/jpeg",
      transparent = FALSE,
      srs = "EPSG:3857", # leaflet uses 3857 internally

      # set some leaflet options
      maxZoom = 18,
      maxNativeZoom = 18,
      minZoom = 12,
      detectRetina = TRUE,
      opacity = 0.9,
      noWrap = TRUE
    )
  ) |>
  # add mask for Stadtgrenze as the tiles cover the entire canton of Zurich
  addPolygons(data = neg_stadtgrenze, stroke = FALSE, fillOpacity = 1, fillColor = "white") |>
  setView(lng = 8.542, lat = 47.37, zoom = 12) |>
  addCircleMarkers(
    data = df_loc,
    # need to convert labels to HTML as a list, otherwise all labels are shown
    # for each point
    label = ~ purrr::map(tooltip, HTML),
    layerId = ~zsid,
    radius = 10,
    stroke = FALSE,
    color = zueriblau,
    fill = zueriblau,
    fillOpacity = 0.9,
    labelOptions = labelOptions(interactive = T),
    clusterOptions = markerClusterOptions(
      showCoverageOnHover = FALSE,
      zoomToBoundsOnClick = TRUE,
      spiderfyOnMaxZoom = TRUE,
      # add JS function to set the color of the clusters (get_zuericolors("qual6b", 6))
      iconCreateFunction = JS("
              function(cluster) {
                return new L.DivIcon({
                  html: '<div style=\"background-color: #FBB900; color: black; border-radius: 50%; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center; font-weight: bold; border: none;\">' + cluster.getChildCount() + '</div>',
                  className: '',
                  iconSize: new L.Point(40, 40)
                });
              }
            ")
    )
  ) |>
  # prevent user from zooming/moving outside the city boundaries
  setMaxBounds(bbox_stadt[["xmin"]], bbox_stadt[["ymin"]], bbox_stadt[["xmax"]], bbox_stadt[["ymax"]])

# currently not possible: change the color of a circleMarker on hover (addCircles
# has highlight options, but instead has no cluster options --> might be the
# better choice with fewer points to plot in case no clustering is required!)

# option for colour base map: use the following call to add WSM tiles
# addWMSTiles(
#   baseUrl = https://www.ogd.stadt-zuerich.ch/mapproxy/service?,
#   layers = "Basiskarte_Zuerich_Raster",
#   attribution = "GeoZ",
#   options = WMSTileOptions(
#     format = "image/jpeg",
#     transparent = FALSE,
#     srs = "EPSG:3857", # leaflet uses 3857 internally
#
#     # Leaflet-Optionen:
#     maxZoom = 18,
#     maxNativeZoom = 18,
#     minZoom = 12,
#     detectRetina = TRUE,
#     opacity = 0.9,
#     noWrap = TRUE
#   )
# )
