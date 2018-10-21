library(leaflet)
library(leaflet.extras)
library(tidyverse)
library(raster)

load("~/Github/DataVisFire/fire_coord.RData")

leaflet(fire_coord) %>%
     addProviderTiles("Esri.WorldImagery") %>%
     addCircles(~ Lon, ~ Lat)

leaflet(fire_coord) %>% 
     addProviderTiles("Esri.WorldImagery") %>%
     addHeatmap(lng= ~Lon, lat= ~Lat,
                blur= 2, max= 1.5, radius= 3)


