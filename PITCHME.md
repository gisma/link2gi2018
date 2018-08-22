# Introduction to link2GI

**Prague, 24th August 2018** - [GEOSTAT 2018](https://geostat-course.org/2018)

Chris Reudenbach 
Faculty of Geography University of Marburg (Germany))

@fa[github fa-0.5x] gisma @fa[twitter fa-1x] @Creuden
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

### Demands and shortcomings
@ul
  - R is a low entry-level scripting language for geo-spatial tasks
  - Plus there is an increasing demand for (complex) spatio-temporal data analysis 
  - Cross platform/ cross software collaboration is still cumbersome
   - restricted user privileges 
  - lacking knowledge of operating system,command line
  - cross platform shortcomings
  - software (R) **and** operating system (whatever) focused point of view 
  - Missing functionality/knowledge leads to broken workflows, so interactive / manual usage of external GIS software is common
    
@ulend
+++

##  Some benefits
- From a typical R-User point of view without either sufficient privileges or not familiar with GIS-software or the operating system it seems to be at least **helpful** to reduce some of this issues

- from a teaching point of view it would be great to avoid the nightmare to adapt individual laptop configurations or lab restrictions.

- from a R-developer point of view it is helpful to enable the integration of fast and relieble algorithms of mature software systems
  
@ulend
---
### Features of link2GI so far

  - supports GRASS 7.x +, SAGA 2.x +, OTB - all releases
  - detects all/most existing intallations of GRASS7, SAGA, and Orfeo Toolbox
  - provides working temporary/permanent user envionments as required by the corresponding GIS software for command line and  wrapper packages `RSAGA`, `rgrass7` usage
  - simplifies OTB calls via a first list-based OTB wrapper 


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
### Hands on
- Use the [vignette](https://github.com/gisma/link2gi2018/blob/master/R/vignette/link2gigeostat.Rmd) for more basic examples
- Dive into the usecases for getting an idea how to use link2GI
---
### Usecases
- [Analysing the ECA&D climatic data](https://github.com/gisma/link2gi2018/blob/master/R/usecases/saga_otb/useCaseGRASS_Neteler2018.R)
- [Derivation of micro climate parameters](https://github.com/gisma/link2gi2018/blob/master/R/usecases/saga_otb/usecasepredict-compet.R.R)

- [SAGA & OTB basic usecase](https://github.com/gisma/link2gi2018/blob/master/R/usecases/saga_otb/usecaseSAGA_OTB.R)

- [Canopy Height Model from UAV derived point clouds](https://github.com/gisma/link2gi2018/blob/master/R/usecases/uav-pc/usecaseCHM.R)

- [beetle spread over high asia](https://github.com/gisma/link2gi2018/blob/master/R/usecases/cost-analysis/useCaseBeetle)

---

  For know have fun crossing the borders 
  
  and
  
  Thank you for attention
  
---
  
  

