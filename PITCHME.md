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

### There is a demand...
@ul
  - R is a low entry-level scripting language 
  - there is  an increasing demand for more complex spatio-temporal data analysis 
  - In cross platform cross softrware usage there are still a lot of  everyday restrictions 
@ulend
+++

### The R-user phenomen 
@ul
  
  - R-users have often a R-ish **and** operating system point of view 
  - R-Users are often use GIS GUIs for visualisation, pre-, inter- and post-processing outside from R which is killing all workflows
    
@ulend
+++

## The operating system phenomenon
@ul
    - restricted user privileges 
    - lacking knowledge of operating system and command line
    - cross platform shortcomings

@ulend

+++ 

##  To summarize
@ul
- from a R-User point of view without either sufficient privileges or not familiar with GIS-software also for fast prototyping it seems to be **helpful** to reduce as many of these problems as possible.

- from a R-teacher point of view if you have 50 and more individually configured Laptops running under strange Linux distributions, Windows versions and MacOS, you will get an idea why it could be comfortable to automate the procedure of finding the correct API-bindings.
  
@ulend
---
### What are the key features of link2GI?

  - GRASS 7.x, SAGA 2.x - current release,OTB - all releases
  - detects all/most existing intallations of GRASS7, SAGA, and Orfeo Toolbox
  - provides correct temporary/permanent user envionments as required by the requested GIS software to support both command line and existing wrapper packages `RSAGA`, `rgrass7` 
  - simplifying OTB calls via a first list-based OTB wrapper 

+++

+++
### GRASS GIS

`GRASS GIS` has the most challenging requirements. It needs a bunch of environment and path variables as **and** a correct setup of the geographical data parameters. The `linkGRASS7` function tries to find all installations let you (optionally) choose the one you want to use and generate the necessary variables. As a result you can use both the rgrass7 package  or the command line `API` of `GRASS`.

+++
### SAGA GIS

`SAGA GIS` is a far easier to set up. Again the `linkSAGA` function tries to find all `SAGA` installations, let you (optionally) choose one and generate the necessary variables. You may also use `RSAGA` but you have to hand over the result of `linkSAGA` like `RSAGA::rsaga.env(path = saga$sagaPath)`. For a straightforward usage you may simply use the  `R` system() call to  interface `R` with the `saga_cmd` API. 

+++ 
### OTB

The `Orfeo Toolbox` (OTB) is a very powerful remote sensing toolbox. It is widely used for classification, filtering and machine learning applications. You will find some of the implemented algorithm within different R packages but **always** much slower or only running on small data chunks. Due to a missing wrapper the linkage is performed to use the command line API of the `OTB`. Currently link2GI provides very basic list-based `OTB` wrapper. 

+++
### GDAL
GDAL is perfectly integrated in R. However in some cases it is beneficial to uses system calls and grab the binaries directly. `link2GI` generates a list of all pathes and commands so you may easily use also python scripts calls and other chains. 

---

### Get an overview what is running on your machine

```R
# load library
require(link2GI)

# find all GRASS GIS installations at the default search location
grass <- link2GI::findGRASS()
print(grass)

# find all SAGA installations at the default search location
saga <- link2GI::findSAGA()
print(saga)

# find all Orfeo Toolbox installations at the default search location
otb <- link2GI::findOTB()
print(otb)
```
---

Maybe you are surprised about the time consuming process (especially under Windows) and also the results. It is the probably fastest brute force way to search the whole device for relevant entries...

Please keep also in mind that the default locations are:
``` R
# running Windows
searchLocation = "C:\"
# running Linux
searchLocation = "/usr"
```
--- 

### Let's use meuse

```R
# get meuse data as sp object
require(link2GI)
require(sp)
require(sf)
# get meuse data as sf object
data(meuse) 
meuse_sf = st_as_sf(meuse, 
                    coords = 
                      c("x", "y"), 
                    crs = 28992, 
                    agr = "constant")

# create a temporary GRASS linkage using the meuse data

linkGRASS7(meuse_sf,select_ver=1)
```
---
## Ok what next?

- usecase basic SAGA OTB
- usecase processing UAV -derived pointclouds
- usecase cost analysis
---

---?code=R/usecases/saga_otb/useCaseSAGA_OTB.R
@[1-6](basic idea)

---
- [SAGA & OTB basic usecase](https://github.com/gisma/link2gi2018/blob/master/R/usecases/saga_otb/usecaseSAGA_OTB.R)

- [Canopy Height Model from UAV derived point clouds](https://github.com/gisma/link2gi2018/blob/master/R/usecases/uav-pc/usecaseCHM.R)

- [beetle spread over high asia](https://github.com/gisma/link2gi2018/blob/master/R/usecases/cost-analysis/useCaseBeetle)

---

  Thank you for attention
  
---
  
  

