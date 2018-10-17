library(leaflet)
library(leaflet.extras)
library(tidyverse)

load("~/Github/DataVisFire/fire_coord.RData")
fire_coord <- as.tibble(coordinates(fire))

leaflet(fire_coord) %>%
     addProviderTiles("Esri.WorldImagery") %>%
     addCircles(~ Lon, ~ Lat)

leaflet(fire_coord) %>% 
     addProviderTiles("Esri.WorldImagery") %>%
     addHeatmap(lng= ~Lon, lat= ~Lat,
                blur= 2, max= 1.5, radius= 3)


