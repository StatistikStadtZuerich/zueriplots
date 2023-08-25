# zueriplots

Dieses Repository dient als Anleitung für die CI/CD-konforme Erstellung von ggplots mithilfe von [zueritheme](https://github.com/StatistikStadtZuerich/zueritheme) und [zuericolors](https://github.com/StatistikStadtZuerich/zuericolors).

Die `ssz_theme(...)`-Funktion aus dem `zueritheme`-Package übernimmt dabei die meisten Styling Funktionen. Bevor losgelegt werden kann, müssen `zueritheme` und `zuericolors` sowie die offizielle Font `HelveticaNeueLTPro` auf dem eigenen Rechner installiert werden.

## HelveticaNeueLTPro

Die Font HelveticaNeueLTPro muss zuerst im Softwarecenter bestellt und installiert werden. Danach wird das `extrafont`-Package benötigt und mit der `font_import()`-Funktion die Schrift installiert. Mit der Funktion `windwosFonts()` sieht man, welche Schriften vom System in R verfügbar sind.

``` r
# install.packages("extrafont")
library(extrafont)
font_import(pattern = "HelveticaNeueLTPro-Roman.ttf")
windowsFonts()
```

## Bar Chart
[Bar Charts](https://r-graph-gallery.com/barplot.html) sind die wohl am häufigsten verwendeten Grafiktypen.

<img src='plots/line_chart.png' />