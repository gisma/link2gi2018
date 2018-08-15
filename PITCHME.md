# Introduction to link2GI

### GEOSTAT Summer School
**Prague, August 2018** - [GEOSTAT 2018](https://geostat-course.org/2018)

---

# What is link2GI?

The [**LINK2gi**](https://CRAN.R-project.org/package=link2GI) package provides an small tool for linking GRASS, SAGA GIS and QGIS as well as other awesome command line tools like the Orfeo Toolbox (OTB) for R users that are not operating system specialists or highly experienced GIS users. 

To clarify If have to do so on 20 ore so individual Windows Laptops you will get an idea why it could be comfortable to automate this procedure.


---
  
## Why link2GI

Taking into account the great capabilities of GRASS like shown by Markus and Veronika or the great accessibility of QGIS as demonstrated by Jannis there seems to be no need for a common meta interface. 

So why then even a package like @color[blue](**link2GI**)?

---

## Because of an increasing demand

R is a widely used entry-level scripting language with low access threshold with an increasing number of users. 

Same with spatiotemporal data analysis 

**However** from a straightforward R-User point of view, for companys or university working places without sufficient privileges, for users that ar not familiar with GIS-software or for fast prototyping across software and systems and so forth... **it could be useful**

---

##  Unfortunately there are some crucial everyday restrictions

@ul
  
  - The R-user phenomen 
    - If necessary a cumbersome, manual use of GIS GUIs for pre-, post-processing of data or data analysis, format conversion, etc. is common 
    - The R-ish point of view of users is focusing on R solution and usually not highly involved in integrating API calls, system depending scripts etc. 
    
  - The operating system phenomenon
    - Different user privileges
    - Limited knowledge of system and command line
    - Strange CLI behaviour dependiong on OS-type, -version and leads to cumbersome (cross platform) collaboration due to code incompatibilities etc. 
    - extreme varying command line interpreter capabilities (Windows, Linux)

@ulend

---

  


---


---

+++
  
  




+++
  
  - next1
  
  - next1.5

- next2
  
---
  
  ## main functions in link2GI
  
  
---
  
  

<!--- ?include=tgrass/link2gigeostat.md --->