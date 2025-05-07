# SSZ Bar Chart -----------------------------------------------------------

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
URL <- "https://data.stadt-zuerich.ch/dataset/bev_bestand_jahr_quartier_alter_herkunft_geschlecht_od3903/download/BEV390OD3903.csv"
df <- fread(URL, encoding = "UTF-8") %>%
  filter(StichtagDatJahr == max(StichtagDatJahr)) %>%
  group_by(StichtagDatJahr, AlterVSort, SexLang) %>%
  summarise(AnzBestWir = sum(AnzBestWir)) %>%
  mutate(Anzahl = case_when(SexLang == "weiblich" ~ AnzBestWir*-1,
                            TRUE ~ AnzBestWir))

# Define Colors
colors <- get_zuericolors(palette = "qual6", nth = 1:2)

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
       aes(x = Anzahl,
           y = as.factor(AlterVSort),
           fill = SexLang)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = colors) +
  scale_y_discrete(breaks = factor(c(0, 25, 50, 75, 100))) +
  scale_x_continuous(labels = c(5000, 2500, 0, 2500, 5000)) +
  labs(title = "Bevölkerungspyramide Stadt Zürich",
       subtitle = paste0(max(df$StichtagDatJahr)),
       x = "Anzahl Personen",
       y = "Alter",
       caption = "Quelle: BVS, Statistik Stadt Zürich") +
  ssz_theme(grid_lines = "none",
            base_family = "Helv",
            base_size = 11) +
  theme(axis.title.y = element_text(
    margin = margin(t = 0, r = -20, b = 0, l = 0)
  ))

# Save Plot
ggsave(
  here("man", "figures", "pyramid_chart.png"),
  p,
  width = 6,
  height = 6
)
