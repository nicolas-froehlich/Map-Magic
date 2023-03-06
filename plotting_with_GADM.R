## Easy administrative unit plotting with GADM

# auf dem Mac bei Lisa hat es folgenderma?en funktioniert, probier das doch mal aus :)

install.packages('rgdal')
# dann R neustarten
# wenn man bei den installs gefragt wird wegen den Bin?rdateien immer 'no' eingeben

install.packages("lintr")
lintr::lint("~/docs/uni/DataStuff/NewHobby/Map-Magic/plotting_with_GADM.R")

###### fuer Maite #####


install.packages('sf')
library(sf)
geo <- st_read("/Users/nf/docs/uni/DataStuff/NewHobby/data/geoBoundaries-DEU-ADM1-all")

names(geo)
maites_values <- c(4.84, 7.6, 40, 4.88, 48, 44, 4.3, 4, 8, 8, 0.84, 8.44, 0.84, 8, 4, 4)
mydata <- data.frame(shapeName = geo$shapeName, prevalence = maites_values)
mydata

## merge shape file with data
final_geo <- merge(geo, mydata, by = "shapeName")
head(final_geo)

## nice plot
ggplot(final_geo) +
  geom_sf(aes(fill = prevalence), color = "black", size = 0.25)  +
  coord_sf() + 
  scale_fill_distiller(name = "prevalence", 
                       palette = "YlGn", 
                       breaks = pretty_breaks(n = 5)) + 
  theme_nothing(legend = TRUE) + 
  labs(title = "Prevalence of X in Germany")


## source https://klein.uk/teaching/viz/datavis-maps/

## load packages
install.packages("raster")
install.packages ("ggplot2")
install.packages("rgeos")
install.packages("maptools")
install.packages("scales")

## download shapefile from gadm.org level=1 -> federal state
library(raster)
states.shp <- getData("GADM", country = "Germany", level = 1)
class(states.shp)
names(states.shp)
states.shp$NAME_1

## fortify shape file to dataframe format
library(rgeos)
library(maptools)
library(ggplot2)
states.shp.f <- fortify(states.shp, region = "NAME_1")
class(states.shp.f)

head(states.shp.f)

## (create random) data to plot on map
num.states <- length(states.shp$NAME_1)
##### HIER! fügst du deine Werte für die 16 Bundesländer ein, Reihenfolge siehe nächster Befehl
states.shp$NAME_1
maites_values <- c(4.84, 5, 2.33, 4.88, 4.8, 4.4, 43, 4, 8, 8, 0.84, 8.44, 0.84, 8, 4, 4)
mydata <- data.frame(id = states.shp$NAME_1, prevalence = maites_values)
mydata

## merge shape file with data
merge.shp.coef <- merge(states.shp.f, mydata, by = "id")
head(merge.shp.coef)


## nice plot
library(scales)
library(ggmap)
ggplot() + geom_polygon(data = merge.shp.coef, 
                        aes(x = long, y = lat, group = group, 
                            fill = prevalence), color = "black", size = 0.25) + 
                            coord_map() + scale_fill_distiller(name = "prevalence", 
                            palette = "YlGn", breaks = pretty_breaks(n = 5)) + 
                            theme_nothing(legend = TRUE) + 
                            labs(title = "Prevalence of X in Germany")




###### fuer Lisa #####



##### Lisa plots her results on a map 

## source https://klein.uk/teaching/viz/datavis-maps/

## load packages
install.packages("raster")
install.packages("ggplot2")
install.packages("rgeos")
install.packages("maptools")
install.packages("scales")

library(raster)
library(rgeos)
library(maptools)
library(ggplot2)
library(scales)
library(ggmap)

misc <- list()
misc$countries <- c("ARG", "ATG", "BHS", "BLZ", "BMU", "BOL", "BRA") #Kuerzel der Staaten, die du untersuchst
# fuege weitere hinzu mit den country codes von hier https://en.wikipedia.org/wiki/ISO_3166-1_alpha-3
states.shp <- do.call("bind", lapply(misc$countries, 
                                     function(x) getData('GADM', country=x, level=0)))

names(states.shp)

states.shp.f <- fortify(states.shp, region = "NAME_0") # Kann ein Weilchen dauern, gedulde dich!
class(states.shp.f)

head(states.shp.f)

## data to plot on map
num.states <- length(states.shp$NAME_0)
##### HIER! in die Liste faegst du deine Werte für die Laender ein, Reihenfolge siehe naechster Befehl
states.shp$NAME_0
lisas_values <- c(1,2,3,4,5,6,7)
mydata <- data.frame(id = states.shp$NAME_0, prevalence = lisas_values)
mydata

## merge shape file with data
merge.shp.coef <- merge(states.shp.f, mydata, by = "id")
head(merge.shp.coef)

## nice plot
library(scales)
library(ggmap)
ggplot() + geom_polygon(data = merge.shp.coef, 
                        aes(x = long, y = lat, group = group, 
                            fill = prevalence), color = "black", size = 0.25) + 
  coord_map() + scale_fill_distiller(name = "prevalence", 
                                     palette = "YlGn", breaks = pretty_breaks(n = 5)) + 
  theme_nothing(legend = TRUE) + 
  labs(title = "Prevalence of X in Central and Latin America")





#### other stuff #####
library(raster)
states <- c('Schleswig-Holstein', 'Mecklenburg-Vorpommern', 'Hamburg', 'Bremen', 
            'Niedersachsen', 'Berlin', 'Brandenburg', 'Sachsen-Anhalt', 
            'Nordrhein-Westfalen', 'Sachsen', 'Thüringen', 'Hessen', 
            'Rheinland-Pfalz', 'Saarland', 'Bayern', 'Baden-Württemberg')

germany <- getData("GADM",country="Germany",level=1)

germany.states <- germany[germany$NAME_1 %in% states,]

germany.bbox <- bbox(germany.states)
xlim <- c(min(germany.bbox[1,1]),max(germany.bbox[1,2]))
ylim <- c(min(germany.bbox[2,1]),max(germany.bbox[2,2]))
plot(germany.states, xlim=xlim, ylim=ylim)


library(ggplot2)
ggplot(germany.states,aes(x=long,y=lat,group=group))+
  geom_path()+
  coord_map()+
  theme_void()

#######


library(raster)
states    <- c('California', 'Nevada', 'Utah', 'Colorado', 'Wyoming', 'Montana', 'Idaho', 'Oregon', 'Washington')
provinces <- c("British Columbia", "Alberta")

us <- getData("GADM",country="USA",level=1)
canada <- getData("GADM",country="CAN",level=1)

us.states <- us[us$NAME_1 %in% states,]
ca.provinces <- canada[canada$NAME_1 %in% provinces,]

us.bbox <- bbox(us.states)
ca.bbox <- bbox(ca.provinces)
xlim <- c(min(us.bbox[1,1],ca.bbox[1,1]),max(us.bbox[1,2],ca.bbox[1,2]))
ylim <- c(min(us.bbox[2,1],ca.bbox[2,1]),max(us.bbox[2,2],ca.bbox[2,2]))
plot(us.states, xlim=xlim, ylim=ylim)
plot(ca.provinces, xlim=xlim, ylim=ylim, add=T)



library(ggplot2)
ggplot(us.states,aes(x=long,y=lat,group=group))+
  geom_path()+
  geom_path(data=ca.provinces)+
  coord_map()

