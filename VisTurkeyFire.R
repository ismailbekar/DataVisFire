setwd("~/Desktop/VisTurkeyFire")
library(raster)
library(dplyr)
library(ggplot2)
library(rgdal)

fire <- read.csv("Data/fire_data.csv")
fire <- fire %>% dplyr::select(Il,Ilce,Day, Month, Year, AnaNeden, TaliNeden, Lon, Lat)

coordinates(fire) <- ~Lon + Lat
class(fire)
fire

Turkey_il <- readOGR("Data/Shapefile/TUR_adm1.shp")
Turkey_il$NAME_1 <- c("Canakkale", "Cankiri", "Corum", "Adana", "Adiyaman", "Afyon", "Agri",
                      "Aksaray", "Amasya", "Ankara", "Antalya", "Ardahan", "Artvin", "Aydin", 
                      "Balikesir", "Bartin", "Batman", "Bayburt", "Bilecik", "Bingol",
                      "Bitlis", "Bolu", "Burdur", "Bursa", "Duzce", "Denizli", "Diyarbakir", 
                      "Edirne", "Elazig", "Erzincan", "Erzurum", "Eskisehir", 
                      "Gumushane", "Gaziantep", "Giresun", "Hakkari", "Hatay", 
                      "Igdir", "Isparta", "Istanbul", "Izmir", "K. Maras", 
                      "Kutahya", "Karabuk", "Karaman", "Kars", "Kastamonu", "Kayseri", 
                      "Kilis", "Kinkkale", "Kirklareli", "Kirsehir", "Kocaeli", "Konya", "Malatya", 
                      "Manisa", "Mardin", "Mersin", "Mugla", "Mus","Nevsehir", "Nigde", "Ordu", 
                      "Osmaniye", "Rize", "Sakarya", "Samsun", "Sanliurfa", "Siirt", "Sinop", 
                      "Sirnak", "Sivas", "Tekirdag", "Tokat", "Trabzon", "Tunceli", "Usak", 
                      "Van","Yalova", "Yozgat", "Zonguldak")

Turkey_il <- spTransform(Turkey_il, "+init=epsg:4326")
proj4string(fire) <- CRS("+init=epsg:4326")

crs(Turkey_il)
crs(fire)

plot(fire, pch= ".")
fire <- raster::intersect(fire, Turkey_il)
plot(fire, pch= ".")

plot(Turkey_il)
plot(fire, add= TRUE, pch= ".")

fire_count <- over(fire, Turkey_il)
fire_count <- as.data.frame(table(fire_count$NAME_1))
fire_count <- add_row(fire_count, Var1= "Igdir", Freq = 0)
names(fire_count) <-  c("NAME_1", "Count")

Turkey_il@data$VARNAME_1 <- NULL
Turkey_il@data$ENGTYPE_1 <- NULL
Turkey_il@data$TYPE_1 <- NULL
Turkey_il@data$ISO <- NULL
Turkey_il@data$ID_0 <- NULL
Turkey_il@data$NAME_0 <- NULL
Turkey_il@data$NL_NAME_1 <- NULL
str(Turkey_il@data)

Turkey_il <- merge(Turkey_il, fire_count, by="NAME_1")
str(Turkey_il@data)

library(RColorBrewer)
library(classInt)

my.palette <- brewer.pal(n = 8, name = "Reds")
breaks.qt <- classIntervals(Turkey_il@data$Count, n = 8, style = "kmeans")
breaks.qt

spplot(Turkey_il, "Count", col= "transparent", col.regions= my.palette, at = breaks.qt$brks)
spplot(Turkey_il, "Count", col= "transparent", col.regions= my.palette, cut= 7, do.log= TRUE)


###################################

Turkey_il$id = rownames(as.data.frame(Turkey_il))

df_Turkey.pts <- fortify(Turkey_il, region = "id")
df_Turkey <- merge(df_Turkey.pts, Turkey_il, by= "id", type='left') # add the attributes back 

ggplot(df_Turkey, aes(long, lat, group=group, fill=Count)) + # the data
          geom_polygon() + # make polygons
          scale_fill_continuous("Total Number of Fires", low = "#fff5f0", high = "#67000d") + # fill with brewer colors
          theme(line = element_blank(),  # remove the background, tickmarks, etc
                axis.text=element_blank(),
                axis.title=element_blank(),
                panel.background = element_blank()) +
          coord_equal()

str(df_Turkey)
