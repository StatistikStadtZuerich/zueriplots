# SSZ Bar Chart -----------------------------------------------------------

# Required Libraries
library(ggplot2)
library(zuericolors)
library(zueritheme)
library(data.table)
library(dplyr)
library(here)
library(showtext)
library(rappdirs)

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
path_to_font <- paste0(user_config_dir(roaming = FALSE, os = "win"), "\\Microsoft\\Windows\\Fonts\\")

font_add(family = "Helv", 
         regular = paste0(path_to_font, "HelveticaNeueLTPro-Roman.ttf"),
         bold = paste0(path_to_font, "HelveticaNeueLTPro-HV_0.ttf"))

# Plotting Resolution Parameters
showtext_auto()
showtext_opts(dpi = 300)

# Plot
plot <- ggplot(data = df,
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
  paste0(here(), "/plots/pyramid_chart.png"),
  plot,
  width = 6,
  height = 6
)
