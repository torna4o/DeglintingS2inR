##################################################
##     ##     ##    ## ### ##     ##    ###     ##
#### #### ### ## ## ##  ## ## ### ## ### ## ### ##
#### #### ### ##   ### # # ## ### ## ### ## ### ##
#### #### ### ## ## ## ##  ##     ## ### ## ### ##
#### ####     ## ## ## ### ## ### ##    ###     ##
##################################################

### Deglinting water for Sentinel-2 MSI according to Hedley et al. (2005)

# Reference
#################################################################################################
# J. D. Hedley, A. R. Harborne & P. J. Mumby (2005)                      
# Technical note: Simple and robust removal of sun glint for mapping shallow-water benthos,
# International Journal of Remote Sensing, 26:10, 2107-2112, DOI: 10.1080/01431160500034086
#################################################################################################


### Part 0 -- Loading required packages and preparation

remove(list=ls())
library(raster)
library(sp)

### Part 1 -- Loading shapefiles and raster satellite GeoTIFF file

img <- brick("C:/2019aug26.tif")  # Insert the GeoTIFF file location between ""
allw <- shapefile("C:/d/deglint26aug.shp") # Insert the shapefile for to-be-deglinted water between ""
sample <- shapefile("C:/d/sample26aug.shp") # Insert the shapefile for user-defined sample area for deglinting between ""

# Projecting the shapefiles and GeoTIFF onto same plane

allw <- spTransform(allw, crs(img)) 
sample <- spTransform(sample, crs(img))

### Part 2 -- Cropping the image for sampling and masking

# Masking the user-defined water part for deglinting

all <- crop(img, extent(allw), snap="out")
alw <- rasterize(allw, all)
all <- mask(x=all, mask=alw)

# Masking the sample part for future linear regressin operations

sam <- crop(img, extent(sample), snap="out")
smp <- rasterize(sample, sam)
sam <- mask(x=sam, mask=smp)

### Part 3 -- Getting the coefficients of linear regressions for deglinting

# Retrieving data from raster to matrix, then do data frame for linear modeling

samval <- getValues(sam)
samval <- as.data.frame(samval)

# Linear models

lin2 <- lm(B2 ~ B8, data=samval)
lin3 <- lm(B3 ~ B8, data=samval)
lin4 <- lm(B4 ~ B8, data=samval)

# Storing slopes of linear models for B4, B3, and B2 RGB bands of Sentinel 2-MSI

bb2 <- coef(lin2)
bb2sl <- bb2[[2]]
bb3 <- coef(lin3)
bb3sl <- bb3[[2]]
bb4 <- coef(lin4)
bb4sl <- bb4[[2]]

# Retrieving minimum NIR (B8) value of the sample region and storing

tem <- summary(samval$B8)
nirmin <- tem[[1]]

### Part 4 -- Raster algebra for sunglint correction of RGB bands

# The formula is : Final pixel(lambda) = Pixel(lambda) - nirslope(lambda)(Pixel(NIR) - Min(NIR))

# Creating new rasterbrick

new <- all

# B2

new$B2 = new$B2 - bb2sl*(new$B8-nirmin)

# Following two lines are to set the minimum to 0 for just convention, optional

a <- summary(new$B2)
new$B2 = new$B2 - a[1]

# B3

new$B3 = new$B3 - bb3sl*(new$B8-nirmin)
b <- summary(new$B3)
new$B3 = new$B3 - b[1]

# B4

new$B4 = new$B4 - bb4sl*(new$B8-nirmin)
c <- summary(new$B4)
new$B4 = new$B4 - c[1]

### Part 5 -- Writing this new raster to a file

writeRaster(new, "deglinted3.tiff")
 



