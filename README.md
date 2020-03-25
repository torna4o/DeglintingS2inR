# DeglintingS2inR

Deglinting operation for Sentinel-2 MSI according to Hedley et al. (2005), the full references to the corresponding paper in APA 6th citation is at the end of this document.

# Introduction

Deglinting might be a required preprocessing step for satellite remote sensing of waterbodies. Sun glints can significantly suppress diffuse radiance coming from water column, can change the ratio of the bands, and consequently most used indices like NDVI, NDWI, etc., and even texture of the water surface appearance. In order to remove or at least subside its impact, several different types of methods were developed, with a relatively recent method and reviewing of existing methods the readers are encouraged to take a look at the manuscript written by Harmel et al., (2018). As it is already difficult to find sufficiently cloudless images for a certain waterbody, it will be extremely beneficial to be able to effectively remove sun glint from the images.

# Aim

To satisfy the need to deglint satellite images, open-source scripts are extremely important. In this way, the researchers can directly retrieve the required code and apply to their images and see the extend of improvement and later report, and when this process get faster the methods will also advance more rapidly. Here, as to the best of my knowledge one of the simplest preprocessing, Hedley's (2005) method was mimicked in R script, which anyone can freely and easily load required packages of "raster" and "sp" and in few minutes obtain resulted satellite image with a deglinted Red (Band 4), Green (Band 3), and Blue (Band 2) bands using NIR band of (Band 8) Sentinel-2 MSI Satellite images. 

# Current workflow of the code

In main steps it can be summarized as in the following line:


*-> Initiation (package loading and file loadings) 
*-> Projecting GeoTIFF and shapefiles onto the same projection 
*-> Cropping the GeoTIFF for both ROI for deglinting and sample region for Hedley's deglinting method 
*-> Generating the linear models for Band 2,3, and 4 of Sentinel 2-MSI and storing relevant data 
*-> Deglinting the corresponding bands (and optionally setting their minimum to 0) 
*-> Writing it to a new GeoTIFF raster file


Adding new bands for deglinting is trivial, will just require copying of linear model and deglinting calculation parts for the new band, and adapting it to another satellite, such as Landsat 8-OLI merely requires changing the band names.
Some enhancements to the code may be parallel computing and other utilities like expected run time calculation according to the number of pixels and bands. 

# Conclusion

As can also be seen from the MIT License, this is just a voluntary project and initial commit, its users will take the full responsibility of using it. However, I am also open to develop better and more correct versions of this and future similar codes *together. 

# References

Harmel, T., Chami, M., Tormos, T., Reynaud, N., & Danis, P.-A. (2018). Sunglint correction of the Multi-Spectral Instrument (MSI)-SENTINEL-2 imagery over inland and sea waters from SWIR bands. Remote Sensing of Environment, 204, 308–321. doi: 10.1016/j.rse.2017.10.022

Hedley, J. D., Harborne, A. R., & Mumby, P. J. (2005). Technical note: Simple and robust removal of sun glint for mapping shallow‐water benthos. International Journal of Remote Sensing, 26(10), 2107–2112. doi: 10.1080/01431160500034086
