#### Friday, June 2th, 2023
#### Nicolas Fröhlich

#### Here, I want to try out and play around with the rayshader package. Most of the code stems from the official rayshade website https://www.rayshader.com/

#### In a recent chat about spatial data related stuff with Tilman Hauk, a former colleague of mine, he recommended the package to me. We challenged ourselves to create a shaded elevation map of the famous Swiss Matterhorn mountain.
#### I'll try...


#### because of dependency conflicts, I had to use the renv package (for the first time). It solved the conflicts.

# install.packages('renv')
# install.packages('devtools')
# library(renv)
# library(devtools)

renv::init(bare = TRUE)

# To install the latest version from Github:
# install.packages("devtools")
devtools::install_github("tylermorganwall/rayshader")
library(rayshader)

# load a map with the raster package.
loadzip = tempfile() # tempfile returns a vector of character strings which can be used as names for temporary files.
download.file("https://tylermw.com/data/dem_01.tif.zip", loadzip) # download the ZIP file and save it to the loadzip file path

localtif = unzip(loadzip, "dem_01.tif") # unzip TIFF file
localraster = raster::raster(localtif) # and store as a raster object
unlink(loadzip) # deletes the zip file from file system to clean up the temporary file

# convert it to an elevation matrix (elmat):
elmat = raster_to_matrix(localraster)

# use another one of rayshader's built-in textures:
elmat %>%
  sphere_shade(texture = "desert") %>%
  plot_map()

#sphere_shade can shift the sun direction:
elmat %>%
  sphere_shade(sunangle = 45, texture = "bw") %>%
  plot_map()


#detect_water and add_water adds a water layer to the map:
elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  plot_map()

#And we can add a raytraced layer from that sun direction as well:
elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  add_shadow(ray_shade(elmat), 0.5) %>%
  plot_map()

# Here we add an ambient occlusion shadow layer, which models 
#lighting from atmospheric scattering:
elmat %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elmat), color = "desert") %>%
  add_shadow(ray_shade(elmat), 0.5) %>%
  add_shadow(ambient_shade(elmat), 0) %>%
  plot_map()


# Rayshader also supports 3D mapping by passing a texture map (either external or one produced by rayshader) into the plot_3d function.
elmat %>%
  sphere_shade(texture = "bw") %>% # played around with the colouring
  add_water(detect_water(elmat), color = "unicorn") %>%
  add_shadow(ray_shade(elmat, zscale = 3), 0.5) %>%
  add_shadow(ambient_shade(elmat), 0) %>%
  plot_3d(elmat, zscale = 10, fov = 0, theta = 135, zoom = 0.75, phi = 45, windowsize = c(1000, 800))
Sys.sleep(0.2)
render_snapshot()






# ok, looks cool
# let's get to the hard part: doing it myself with the Matterhorn data

#### I think the relevant GeoTIFF data can be found here: https://earthexplorer.usgs.gov/
#### by selecting “Digital Elevation” under the "Data Sets" tab and choosing the SRTM option, then the 1-Arc second Global dataset
#### documentation see: https://www.usgs.gov/centers/eros/science/usgs-eros-archive-digital-elevation-shuttle-radar-topography-mission-srtm?qt-science_center_objects=0#qt-science_center_objects
#### a (free) registration at USGS is necessary for downloading






# step one: read in the .tif data and get it into RasterLayer format
library(raster)
matterhorn = raster::raster("n45_e007_1arc_v3.tif")
print(matterhorn)

# check the coordinates of Matterhorn (45.97, 7.65) and use a rectangle around it (trial and error) to crop

# medium margin around Matterhorn
xmin <- 7.5   # Minimum x-coordinate
xmax <- 7.7   # Maximum x-coordinate
ymin <- 45.8   # Minimum y-coordinate
ymax <- 46.0   # Maximum y-coordinate

## very small margin around Matterhorn
xmin <- 7.627   # Minimum x-coordinate
xmax <- 7.694   # Maximum x-coordinate
ymin <- 45.965   # Minimum y-coordinate
ymax <- 46.0   # Maximum y-coordinate

# Create a rectangular extent object
crop_extent <- extent(xmin, xmax, ymin, ymax)

# Crop the RasterLayer to the specified rectangle
matterhorn_cropped <- crop(matterhorn, crop_extent)

# Print information about the cropped raster
print(matterhorn_cropped)

elmat = raster_to_matrix(matterhorn_cropped)


elmat %>%
  height_shade(texture = topo.colors(256)) %>%
  add_shadow(ray_shade(elmat,zscale=50),0.3) %>%
  plot_map()


## check whether the black parts are NAs!




########

# # setwd("~/docs/uni/DataStuff/Spatial/Map-Magic/rayshader_tryout")
# 
# # trying with terra package
# install.packages("terra")
# library(terra)
# #### from https://rspatial.org/spatial/5-files.html
# f <- system.file("/code.R", package="terra")
# basename(f)
# 
# r <- terra::rast("/dem_01.tif")
# r