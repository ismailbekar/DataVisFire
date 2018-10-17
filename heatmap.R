
leaflet(df_Turkey) %>%
     addProviderTiles("Esri.WorldImagery") %>%
     addMarkers(~ long, ~ lat)  

leaflet(fire) %>% 
     addProviderTiles("Esri.WorldImagery") %>%
     addHeatmap(lng= ~Lon, lat= ~Lat,
                blur= 5, max= 0.8, radius= 8)


