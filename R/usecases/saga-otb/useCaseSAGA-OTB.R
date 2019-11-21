#' The uscase shows the straightforward calls of SAGA and OTB command line tools
#' additionally the alternative usage of the corresponding RSAGA wrapper call is 
#' 
#' required packages used

# required packages
require(link2GI)
require(RSAGA)
require(curl)
require(raster)
library(mapview)

# os switch for permant project folder
if (Sys.info()["sysname"] == "Windows"){
  projRootDir<-"C:/Users/User/Documents/proj/tutorials/link2gi2018/saga-otb"
} else {
  projRootDir<-"~/proj/tutorials/link2gi2018/saga-otb"
}

## define proj subfolders
projFolders = c("data/","run/","las/")

# set export folder pathes as global to TRUE
global = TRUE

# define prefix for global variables 
path_prefix = "path_SO_"

# -- link2GI -- create/assign project structure
# -- please mind that the pathes are exported as global variables
paths<-link2GI::initProj(projRootDir = projRootDir,
                         projFolders = projFolders,
                         global = global,
                         path_prefix = path_prefix)

# overide OS related trailing backslash issue
unzip_path_run<-ifelse(Sys.info()["sysname"]=="Windows", sub("/$", "",path_SO_run),path_SO_run)

# delete all runtime files
unlink(paste0(path_SO_run,"*"), force = TRUE)

# download the tutorial data set 
url <- "https://github.com/gisma/gismaData/raw/master/uavRst/data/tutorial.zip"
res <- curl::curl_download(url, paste0(path_SO_run,"tutorial.zip"))
utils::unzip(zipfile = res, exdir = unzip_path_SO_run)

# check if exsiting and create the links to the GI software
findSAGA()
findOTB()
# link SAGA
saga<-linkSAGA(ver_select = TRUE)
# link OTB
otb<-linkOTB()

## create the environment variable for RSAGA calls
## NOTE this is obligatory if you want to use a defined SAGA version
## to override the rigid search of RSAGA itself
env<-RSAGA::rsaga.env(path = saga$sagaPath)

#  define DEM name
demFileName <- Sys.glob(paths = paste0(path_SO_run,"chm*","tif"))[1]

# read DEM
rdem<-raster::raster( demFileName)

# eport it to SAGA 
raster::writeRaster(rdem,paste0(path_SO_run,"SAGA_dem.sdat"),overwrite = TRUE,NAflag = 0)

# (SAGA_API) standard morhpometry via system call
# http://www.saga-gis.org/saga_tool_doc/6.4.0/ta_morphometry_0.html
system(paste0(saga$sagaCmd," ta_morphometry 0 ",
              " -ELEVATION ", path_SO_run,"SAGA_dem.sgrd",
              " -UNIT_SLOPE 1 ",
              " -UNIT_ASPECT 1 ",
              " -SLOPE ",path_SO_run,"rt_slope.sgrd ", 
              " -ASPECT ",path_SO_run,"rt_aspect.sgrd ",
              " -C_TANG ",path_SO_run,"rt_tangcurve.sgrd ",
              " -C_PROF ",path_SO_run,"rt_profcurve.sgrd ",
              " -C_MINI ",path_SO_run,"rt_mincurve.sgrd ",
              " -C_MAXI ",path_SO_run,"rt_maxcurve.sgrd"))

# (RSAGA) standard morhpometry via  RSAGA wrapper
# http://www.saga-gis.org/saga_tool_doc/6.4.0/ta_morphometry_0.html
RSAGA::rsaga.geoprocessor(lib = "ta_morphometry", module = 0,
                          param = list(ELEVATION = paste(path_SO_run,"SAGA_dem.sgrd", sep = ""), 
                                       UNIT_SLOPE = 1,
                                       UNIT_ASPECT = 1, 
                                       SLOPE = paste(path_SO_run,"SLOPE.sgrd", sep = ""),
                                       ASPECT = paste(path_SO_run,"ASPECT.sgrd", sep = ""),
                                       C_PROF = paste(path_SO_run,"C_PROF.sgrd", sep = ""),
                                       C_TANG = paste(path_SO_run,"C_TANG.sgrd", sep = ""),
                                       C_MINI = paste(path_SO_run,"C_MINI.sgrd", sep = ""),
                                       C_MAXI = paste(path_SO_run,"C_MAXI.sgrd", sep = "")),
                          show.output.on.console = TRUE, invisible = TRUE,
                          env = env)

# (RSAGA) just another example, multiscale morhpometry via RSAGA wrapper
# http://www.saga-gis.org/saga_tool_doc/6.4.0/ta_morphometry_24.html
RSAGA::rsaga.geoprocessor(lib = "ta_morphometry", module = 28,
                          param = list(DEM = paste(path_SO_run,"SAGA_dem.sgrd", sep = ""), 
                                       SCALE_MIN = 1,
                                       SCALE_MAX = 8,
                                       SCALE_NUM = 2,
                                       TPI = paste(path_SO_run,"MTPI.sgrd", sep = "")),
                          show.output.on.console = TRUE,invisible = TRUE,
                          env = env)

mapview::mapview(raster::raster(paste(path_SO_run,"MTPI.sdat", sep = "")))  


### basic OTB example tackling it down by knowing the command line parameters
### we choose LocalStatisticExtraction 
# https://www.orfeo-toolbox.org/CookBook/Applications/app_LocalStatisticExtraction.html


## for the example we use the edge detection, 
algoKeyword<- "LocalStatisticExtraction"

## extract the command list for the choosen algorithm 
cmd<-parseOTBFunction(algo = algoKeyword, gili = otblink)


## define the mandantory arguments all other will be default
cmd$input  <- demFileName
cmd$out <- file.path(path_SO_run,"otb_stat.tif")
cmd$radius <- 5


## run algorithm
retStack<-runOTB(cmd,gili = otblink,quiet = FALSE)

## plot raster
mapview::mapview(retStack)


## plot raster
mapview::mapview(raster::raster(outName))

