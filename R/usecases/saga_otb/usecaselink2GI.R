#'The uscase shows the straightforward calls of SAGA and OTB command line tools
#'additionally the alternative usage of the coresponding RSAGA call is 
# required packages used
require(RSAGA)
require(curl)
require(link2GI)
require(raster)

# os switch for permant project folder
if (Sys.info()["sysname"] == "Windows"){
  projRootDir<-"C:/Users/User/Documents/proj/tutorials/geostat18"
} else {
  projRootDir<-"~/proj/tutorials/geostat18"
}

## define proj subfolders
projFolders = c("data/","data/ref/","output/","run/","las/","scr/")

# set export folder pathes as global to TRUE
global = TRUE

# define prefix for global variables 
path_prefix = "path_"


# -- link2GI -- create/assign project structure
# -- please mind that the pathes are exported as global variables
paths<-link2GI::initProj(projRootDir = projRootDir,
                         projFolders = projFolders,
                         global = global,
                         path_prefix = path_prefix)

# overide OS related trailing backslash issue
unzip_path_run<-ifelse(Sys.info()["sysname"]=="Windows", sub("/$", "",path_run),path_run)

#setwd(path_run)       

unlink(paste0(path_run,"*"), force = TRUE)

## download the tutorial data set 
url <- "https://github.com/gisma/gismaData/raw/master/uavRst/data/tutorial.zip"
res <- curl::curl_download(url, paste0(path_run,"tutorial.zip"))
utils::unzip(zipfile = res, exdir = unzip_path_run)

# create the links to the GI software
## giLinks<-uavRst::get_gi()
saga<-linkSAGA(ver_select = T)
otb<-linkOTB()

## create the environment variable for RSAGA calls
env<-RSAGA::rsaga.env(path = saga$sagaPath)


demFileName <- Sys.glob(paths = paste0(path_run,"chm*","tif"))[1]
rdem<-raster::raster( demFileName)
raster::writeRaster(rdem,paste0(path_run,"SAGA_dem.sdat"),overwrite = TRUE,NAflag = 0)

# (SAGA) standard morhpometry 
system(paste0(saga$sagaCmd," ta_morphometry 0 ",
              " -ELEVATION ", path_run,currentName,
              " -UNIT_SLOPE 1 ",
              " -UNIT_ASPECT 1 ",
              " -SLOPE ",path_run,"rt_slope.sgrd ", 
              " -ASPECT ",path_run,"rt_aspect.sgrd ",
              " -C_TANG ",path_run,"rt_tangcurve.sgrd ",
              " -C_PROF ",path_run,"rt_profcurve.sgrd ",
              " -C_MINI ",path_run,"rt_mincurve.sgrd ",
              " -C_MAXI ",path_run,"rt_maxcurve.sgrd"))


RSAGA::rsaga.geoprocessor(lib = "ta_morphometry", module = 0,
                          param = list(ELEVATION = paste(path_run,"SAGA_dem.sgrd", sep = ""), 
                                       UNIT_SLOPE = 1,
                                       UNIT_ASPECT = 1, 
                                       SLOPE = paste(path_run,"SLOPE.sgrd", sep = ""),
                                       ASPECT = paste(path_run,"ASPECT.sgrd", sep = ""),
                                       C_GENE = paste(path_run,"C_GENE.sgrd", sep = ""),
                                       C_PROF = paste(path_run,"C_PROF.sgrd", sep = ""),
                                       C_PLAN = paste(path_run,"C_PLAN.sgrd", sep = ""),
                                       C_TANG = paste(path_run,"C_TANG.sgrd", sep = ""),
                                       C_LONG = paste(path_run,"C_LONG.sgrd", sep = ""),
                                       C_CROS = paste(path_run,"C_CROS.sgrd", sep = ""),
                                       C_MINI = paste(path_run,"C_MINI.sgrd", sep = ""),
                                       C_MAXI = paste(path_run,"C_MAXI.sgrd", sep = ""),
                                       C_TOTA = paste(path_run,"C_TOTA.sgrd", sep = ""),
                                       C_ROTO = paste(path_run,"C_ROTO.sgrd", sep = ""),
                                       METHOD = 6),
                          show.output.on.console = TRUE, invisible = TRUE,
                          env = env)

RSAGA::rsaga.geoprocessor(lib = "ta_morphometry", module = 28,
                          param = list(DEM = paste(path_run,"SAGA_dem.sgrd", sep = ""), 
                                       SCALE_MIN = 1,
                                       SCALE_MAX = 8,
                                       SCALE_NUM = 2,
                                       TPI = paste(path_run,"MTPI.sgrd", sep = "")),
                          show.output.on.console = TRUE,invisible = TRUE,
                          env = env)

raster::plot(raster::raster(paste(path_run,"MTPI.sdat", sep = "")))      


command<-paste0(otb$pathOTB,"otbcli_LocalStatisticExtraction")
command<-paste(command, " -in ", demFileName )
command<-paste(command, " -channel ", 1)
command<-paste(command, " -out ", paste0(path_run,"otb_stat.tif"))
command<-paste(command, " -radius ",15)
system(command,intern = TRUE,ignore.stdout = TRUE,show.output.on.console = FALSE) 
raster::plot(raster::raster(paste0(path_run,"otb_stat.tif")))

### basic OTB example tackling it down by knowing the command parameters
## define module name (executable)
command<-paste0(otb$pathOTB,"otbcli_LocalStatisticExtraction")
## define concatenate the input filname
command<-paste(command, " -in ", demFileName )
## define concatenate the channel (band)
command<-paste(command, " -channel ", 1)
## define concatenate the output filname
command<-paste(command, " -out ", paste0(path_run,"otb_stat.tif"))
## define kernel radius
command<-paste(command, " -radius ",15)
## make the API call
system(command,intern = TRUE,ignore.stdout = TRUE,show.output.on.console = TRUE) 

raster::plot(raster::raster(paste0(path_run,"otb_stat.tif")))


## if you do not want to parse it by yourself 
## parse all modules

algo<-parseOTBAlgorithms(gili = otb)


## take edge detection
otb_algorithm<-algo[27]
algo_cmd<-parseOTBFunction(algo = otb_algorithm,gili = otb)
## print the current command
print(algo_cmd)

### usecase

## link to OTB
otblink<-link2GI::linkOTB()
path_OTB<-otblink$pathOTB

## get data
setwd(tempdir())
## get some typical data as provided by the authority
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

##create raster
retStack<-assign(outName,raster::raster(outName))


## plot raster
raster::plot(retStack)

