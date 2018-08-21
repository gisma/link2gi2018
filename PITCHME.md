# Introduction to link2GI

### GEOSTAT Summer School
**Prague, 24th August 2018** - [GEOSTAT 2018](https://geostat-course.org/2018)

Chris Reudenbach



---
### About me:

- Faculty of Geography University of Marburg (Germany)
 originally atmosperic and climate remote sensing and numerical modeling
- working on several fields of GIS and RS most of the time trying to solve problems coming along
- last few years joing the spatial R world using it as a lingua franca for linking whatever together 

reudenbach@uni-marburg.de

@creuden

---
### Why this talk?
- To have an excuse to join the meeting and learn
- To show how fast and dirty you may use tons of great software out of the R-universe
- To find out if it make sense to devolp the link2GI tool as a comprehensive wrap-the-wrapper tool
---
### What is link2GI?

The [**LINK2gi**](https://CRAN.R-project.org/package=link2GI) package provides an small tool for linking GRASS, SAGA GIS and QGIS as well as other awesome command line tools like the Orfeo Toolbox (OTB) for R users that are not operating system specialists or highly experienced GIS users. 


---
  
### Why link2GI...?

Taking into account the great capabilities of GRASS like shown by Markus and Veronika or the great accessibility of QGIS as demonstrated by Jannis there seems to be no need for a common meta interface. 

So why then even a package like @color[blue](**link2GI**)?

---

### Increasing demands...
@ul
  - R is a widely used entry-level scripting language with low access threshold with an increasing number of users. 
  - Increasing demand also for spatiotemporal data analysis 
  - Still a lot of crucial everyday restrictions 
@ulend
+++

### The R-user phenomen 
@ul
  
  - If necessary a cumbersome, manual use of GIS GUIs for pre-, post-processing of data or data analysis, format conversion, etc. is common 
  - The R-ish point of view of users is focusing on R solution and usually not highly involved in integrating API calls, system depending scripts etc. 
    
@ulend
+++

## The operating system phenomenon
@ul
    - Different and often user privileges
    - Limited knowledge of system and command line
    - Strange CLI behaviour dependiong on OS-type, -version and leads to cumbersome (cross platform) collaboration due to code incompatibilities etc. 
    - extreme varying command line interpreter capabilities (Windows, Linux)

@ulend

--- 

##  If summarized
@ul
- from a R-User point of view without either sufficient privileges or not familiar with GIS-software also for fast prototyping it seems to be **helpful** to reduce as many of these problems as possible.
- from a R-teacher point of view if you have 50 and more individually configured Laptops running under strange Linux distributions, Windows versions and MacOS, you will get an idea why it could be comfortable to automate the procedure of finding the correct API-bindings.
  
@ulend
---
### What are the key features so far?

  - detecting all/most existing intallations of GRASS7, SAGA, and Orfeo Toolbox as well as GDAL binaries
    - providing a correct temporary user envionment as required by the requested GIS software
    - providing corresponding variables for an easy use of direct system calls
    - providing seamless integration in the well known wrappper packages RSAGA, rgrass7 
    - providing a alpha version of a simple OTB wrapper 
    - providing some small helper functions 

+++

### R-dependencies
'raster', 'rgdal', 'gdalUtils', 'rgrass7', 'sp', 'sf'

+++
###  Supported GIS software 

  - GRASS 7.x
  - SAGA 2.x - current release
  - OTB - all releases
  - GDAL binaries - all releases

+++
### GRASS GIS

`GRASS GIS` has the most challenging requirements. It needs a bunch of environment and path variables as **and** a correct setup of the geographical data parameters. The `linkGRASS7` function tries to find all installations let you (optionally) choose the one you want to use and generate the necessary variables. As a result you can use both the rgrass7 package  or the command line `API` of `GRASS`.

--- 
### SAGA GIS

`SAGA GIS` is a far easier to set up. Again the `linkSAGA` function tries to find all `SAGA` installations, let you (optionally) choose one and generate the necessary variables. You may also use `RSAGA` but you have to hand over the result of `linkSAGA` like `RSAGA::rsaga.env(path = saga$sagaPath)`. For a straightforward usage you may simply use the  `R` system() call to  interface `R` with the `saga_cmd` API. 

--- 
### OTB

The `Orfeo Toolbox` (OTB) is a very powerful remote sensing toolbox. It is widely used for classification, filtering and machine learning applications. You will find some of the implemented algorithm within different R packages but **always** much slower or only running on small data chunks. Due to a missing wrapper the linkage is performed to use the command line API of the `OTB`. Currently link2GI provides very basic list-based `OTB` wrapper. 

--- 
### GDAL
GDAL is perfectly integrated in R. However in some cases it is beneficial to uses system calls and grab the binaries directly. `link2GI` generates a list of all pathes and commands so you may easily use also python scripts calls and other chains. 

---
## Basic Usage
### Get an overview what is running on your machine
  
```R
# find all GRASS GIS installations at the default search location
grass <- link2GI::findGRASS()
print(grass)

# Same with SAGA and OTB

# find all SAGA GIS installations at the default search location
require(link2GI)
saga <- link2GI::findSAGA()
print(saga)

otb <- link2GI::findOTB()
print(otb)
```
Maybe you are surprised about the time consuming process (especially under Windows) and also the results. It is the probably fastest brute force way to search the whole device for relevant entries...

Please keep also in mind that the default locations are:
```
# running Windows
C:\
# running Linux
/usr
```
--- 
### Linking the software

```R
# get meuse data as sp object
require(link2GI)
require(sf)
# get meuse data as sf object
data(meuse) 
meuse_sf = st_as_sf(meuse, 
                    coords = 
                      c("x", "y"), 
                    crs = 28992, 
                    agr = "constant")

# create a temporary GRASS linkage using the meuse data

linkGRASS7(meuse_sf)
```
---

---?code=R/usecases/cost-analysis/useCaseBeetle.R&title=UseCase running Beetles aka cost analysis



@[1-6](load libraries and setup arguments)
@[7-11](Setup project structure)
@[13](Load beetle position)
@[19](Load DEM file)
@[23-25](Setup and link GRASS using the data set)
@[27-31](Cost analysis wrapper function)

---
  
```R
require(raster)
require(sp)
require(gdalUtils)
require(rgdal)
tci<-FALSE
projRootDir = "~/proj/beetle"
link2GI::initProj(projRootDir = projRootDir, 
                  projFolders =  c("run/","cost/"),
                  global = TRUE,
                  path_prefix ="path_" )

beetleLocs<-read.csv2("~/proj/beetle/beetle.csv",header = TRUE,sep = ',',dec = '.',stringsAsFactors=FALSE)

```
---

  ### main functions in link2GI
  
  
---
  
  

