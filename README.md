# zueriplots

Dieses Repository dient als Anleitung für die CI/CD-konforme Erstellung von ggplots mithilfe von [zueritheme](https://github.com/StatistikStadtZuerich/zueritheme) und [zuericolors](https://github.com/StatistikStadtZuerich/zuericolors).

Die `ssz_theme(...)`-Funktion aus dem `zueritheme`-Package übernimmt dabei die meisten Styling-Aufgaben. Bevor losgelegt werden kann, müssen `zueritheme` und `zuericolors` sowie die offizielle Font `HelveticaNeueLTPro` auf dem eigenen Rechner installiert werden.

## HelveticaNeueLTPro

Die Font HelveticaNeueLTPro muss zuerst im Softwarecenter bestellt und installiert werden. Danach wird das `extrafont`-Package benötigt und mit der `font_import()`-Funktion die Schrift installiert. Mit der Funktion `windwosFonts()` sieht man, welche Schriften vom System in R verfügbar sind.

``` r
# install.packages("extrafont")
library(extrafont)
font_import(pattern = "HelveticaNeueLTPro-Roman.ttf")
windowsFonts()
```

## Zusätzliches, manuelles Styling
Die `ssz_theme(...)`-Funktion übernimmt nicht ganz alle Styling-Aufgaben, welche das CI/CD der Stadt Zürich vorschrebit. Namentlich betrifft dies die Position der Achsenbeschriftung sowie den 1000-Seperator.

### Achsenbeschriftungen
Die Achsenbeschriftungen bzw. ihre Position und Margin orientieren sich bei `ggplot2` an den Achsen-Labels. In `zueritheme` wird die z.B. die Y-Achsenbeschriftungen oben links an der Y-Achse rechtsbündig an den Achsen-Labels positioniert:

<img src='pics/axis_text.PNG' align="left" height="138.5" />

Da  die Position der Achsenbeschriftungen daher von der Skalierung (oder den Kategorien) der dargestellten Variable abhängig ist, muss die Beschriftung mit der `margin()`-Funktion positioniert werden.

``` r
ggplot(...) +
geom_bar(...) +
ssz_theme(grid_lines = "y") +
theme(axis.title.y = element_text(
  margin = margin(t = 0, r = -27, b = 0, l = 0)
))
```

### 1000-Seperator
Eine Funktion, welche eine Abstand 

## Bar Chart
[Bar Charts](https://r-graph-gallery.com/barplot.html) sind die wohl am häufigsten verwendeten Grafiktypen.

<img src='plots/line_chart.png' />