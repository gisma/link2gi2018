# link2gi2018
 hands-on tutorial for using link2GI
 
 During the [GEOSTAT 2018](http://opengeohub.org/node/146) in Prague some more complex usescases have been presented.

## Find slides and materials
[Presentation](https://gisma.github.io/link2gi2018/link2gi2018.html#1)slides
[Github Repository](https://github.com/gisma/link2gi2018) github repository.



## Prerequisites
Please check the R dependencies:

```r
install.packages(c("sf", "raster",  "rgdal",  "tools", "rgrass7", "sp", "RSAGA", "link2GI"))

# for the Canopy height model usecase you need to install uavRst
devtools::install_github("r-spatial/uavRst", ref = "master")

```

In addition you need at least one installation of the following GIS software.

- For `GRASS`- and `SAGA-GIS` follow the [RQGIS installation instructions](https://github.com/jannes-m/RQGIS/blob/master/vignettes/install_guide.Rmd) as provided by Jannes Muenchow. For standalone GRASS you may have a look at the the [geostat2018 instructions](https://gitlab.com/veroandreo/grass-gis-geostat-2018) as provided by Veronica Andreos.
- For installing the `Orfeo Toolbox`, please follow the OTB cookbook [installation instructions](https://www.orfeo-toolbox.org/CookBook/Installation.html).

Please download the data and scripts for the exercises.

**PLEASE NOTE:** 

If you run the following code you will create the folder *link2gi-master* in your **home folder**. During the tutorial it is assumed to be the root folder.


```r
url <- "https://github.com/gisma/link2gi2018/archive/master.zip"
res <- curl::curl_download(url, paste0(tmpDir(),"master.zip"))
utils::unzip(zipfile = res, exdir = "~")
```
### The examples

- Basic usage of SAGA and OTB calls - [SAGA & OTB basic usecase](https://github.com/gisma/link2gi2018/blob/master/R/usecases/saga-otb/useCaseSAGA-OTB.R)

- Wrapping a [GRASS GIS example](https://neteler.gitlab.io/grass-gis-analysis/02_grass-gis_ecad_analysis/) of Markus Neteler as presented on GEOSTAT 2018 - [Analysing the ECA&D climatic data - reloaded](https://github.com/gisma/link2gi2018/blob/master/R/usecases/grass/useCaseGRASS-Neteler2018.R)

- Performing a GRASS based cost analysis on a huge cost raster - [Beetle spread over high asia](https://github.com/gisma/link2gi2018/blob/master/R/usecases/cost-analysis/useCaseBeetle.R)

- Deriving a canopy height model using a mixed API approach - [Canopy Height Model from UAV derived point clouds](https://github.com/gisma/link2gi2018/blob/master/R/usecases/uav-pc/useCaseCHM.R)

