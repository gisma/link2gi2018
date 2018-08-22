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
### mention we use the otb variable for determing the pathes

## define module name (executable)
command<-paste0(otb$pathOTB,"otbcli_LocalStatisticExtraction")
## define concatenate the input filname
command<-paste(command, " -in ", demFileName )
## define concatenate the channel (band)
command<-paste(command, " -channel ", 1)
## define concatenate the output filname
command<-paste(command, " -out ", paste0(path_SO_run,"otb_stat.tif"))
## define kernel radius
command<-paste(command, " -radius ",15)

## make the API call
system(command,intern = TRUE,ignore.stdout = TRUE,show.output.on.console = TRUE) 

mapview::mapview(raster::raster(paste0(path_SO_run,"otb_stat.tif")))

## if you do not want read and copy and paste the documentation 
## you may use a very simple parser

## parse all modules 
algo<-parseOTBAlgorithms(gili = otb)

## take edge detection
otb_algorithm<-algo[27]
algo_cmd<-parseOTBFunction(algo = otb_algorithm,gili = otb)

## print the current command
print(paste(names(algo_cmd),algo_cmd,collapse = " "))

### full usecase 
## (again) link to OTB
otblink<-link2GI::linkOTB()
path_OTB<-otblink$pathOTB

## get data
setwd(tempdir())
## get some typical data as provided by the Bavarian authority
url<-"http://www.ldbv.bayern.de/file/zip/5619/DOP%2040_CIR.zip"
res <- curl::curl_download(url, "testdata.zip")
unzip(res,junkpaths = TRUE,overwrite = TRUE)

## get all modules
algo<-parseOTBAlgorithms(gili = otblink)

## use edge detection 
algo_cmd<-parseOTBFunction(algo = algo[27],gili = otblink)

## set arguments
algo_cmd$`-progress`<-1
algo_cmd$`-in`<- file.path(getwd(),"4490600_5321400.tif")
algo_cmd$`-filter`<- "sobel"

## create out name
outName<-paste0(getwd(),"/out",algo_cmd$`-filter`,".tif")
algo_cmd$`-out`<- outName

# if the filter key word is touzi we need anisotropic radius parameters
if (filter == "touzi") {
  algo_cmd$`-filter.touzi.xradius`<- filter.touzi.xradius
  algo_cmd$`-filter.touzi.yradius`<- filter.touzi.yradius
}

## generate basic command 
command<-paste0(path_OTB,"otbcli_",otb_algorithm," ")

## generate full command
command<-paste(command,paste(names(algo_cmd),algo_cmd,collapse = " "))

## make the system call
system(command,intern = TRUE)


## plot raster
mapview::mapview(raster::raster(outName))

