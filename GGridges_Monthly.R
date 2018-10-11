library(ggridges)
library(tidyverse)

fire$fire <- 1
fire$Day <- as.factor(fire$Day) 
fire$Month <- as.factor(fire$Month) 
fire$Year <- as.factor(fire$Year) 

fire %>% 
          arrange(Il, Ilce, Year, Month, Day) %>% 
          group_by(Month) %>% 
          mutate(TF = sum(fire)) %>%
          filter(Year == "2014") %>% 
          ggplot(aes(x = TF, y = Month, fill= Month)) +
          geom_density_ridges(scale = 2, size = 0.15, rel_min_height = 0.001, alpha = .8) +
          labs(x = "Fire Count",
               y = "Monhts",
               fill= "Months",
               title = "Monthly Distribution of Fires in Turkey",
               caption = "Data Source: Ministry of Forestry | Plot by @fire_ecologist" ) +
          theme_light()

