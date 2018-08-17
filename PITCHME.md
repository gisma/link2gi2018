# Introduction to link2GI

### GEOSTAT Summer School
**Prague, August 2018** - [GEOSTAT 2018](https://geostat-course.org/2018)

---

# What is link2GI?

The [**LINK2gi**](https://CRAN.R-project.org/package=link2GI) package provides an small tool for linking GRASS, SAGA GIS and QGIS as well as other awesome command line tools like the Orfeo Toolbox (OTB) for R users that are not operating system specialists or highly experienced GIS users. 

To clarify If have to do so on 20 ore so individual Windows Laptops you will get an idea why it could be comfortable to automate this procedure.


---
  
## Why link2GI...?

Taking into account the great capabilities of GRASS like shown by Markus and Veronika or the great accessibility of QGIS as demonstrated by Jannis there seems to be no need for a common meta interface. 

So why then even a package like @color[blue](**link2GI**)?

---

## Increasing demand

  - R is a widely used entry-level scripting language with low access threshold with an increasing number of users. 

  - Same with spatiotemporal data analysis 
  - Crucial everyday restrictions 

+++

## The R-user phenomen 
@ul
  

    - If necessary a cumbersome, manual use of GIS GUIs for pre-, post-processing of data or data analysis, format conversion, etc. is common 
    - The R-ish point of view of users is focusing on R solution and usually not highly involved in integrating API calls, system depending scripts etc. 

+++

## The operating system phenomenon
    - Different user privileges
    - Limited knowledge of system and command line
    - Strange CLI behaviour dependiong on OS-type, -version and leads to cumbersome (cross platform) collaboration due to code incompatibilities etc. 
    - extreme varying command line interpreter capabilities (Windows, Linux)

@ulend

--- 
## ... last but not least

from a R-User point of view without either sufficient privileges or not familiar with GIS-software also for fast prototyping it seems to be **helpful** to reduce as many of these problems as possible.

  

---
## What are the key features so far?

  - detecting existing intallations of GRASS7, SAGA, and Orfeo Toolbox
  - setting up correct user envionments as required by the GIS software
    - providing variables for easy direct system calls
    - providing seamless integration in the well known wrappper packages RSAGA, rgrass7 
  - providing a alpha version of a simple OTB wrapper 
  - providing some small tools like project structure setup etc

+++

## R-dependencies
'raster', 'rgdal', 'gdalUtils', 'rgrass7', 'sp', 'sf'

+++
##  Supported GIS software 

  - GRASS 7.x
  - SAGA 2.x - current release
  - OTB all releases
  - GDAL binaries all releases

---
  
  




+++
  
  - next1
  
  - next1.5

- next2
  
---
  
  ## main functions in link2GI
  
  
---
  
  

<!--- ?include=tgrass/link2gigeostat.md --->