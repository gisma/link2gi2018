## Not run: 
# required packages
require(uavRst)
require(curl)
require(link2GI)

# project folder
if (Sys.info()["sysname"] == "Windows"){
  projRootDir<-"C:/Users/User/Documents/proj/tutorials/geostat18"
} else {
  projRootDir<-"~/proj/tutorials/geostat18"
}

# proj subfolders
projFolders = c("data/","data/ref/","output/","run/","las/")

# export folders as global
global = TRUE

# with folder name plus following prefix
path_prefix = "path_"



# create subfolders please mind that the pathes are exported as global variables
paths<-link2GI::initProj(projRootDir = projRootDir,
                         projFolders = projFolders,
                         global = global,
                         path_prefix = path_prefix)

# overide trailing backslash issue
unzip_path_run<-ifelse(Sys.info()["sysname"]=="Windows", sub("/$", "",path_run),path_run)
setwd(path_run)       

unlink(paste0(path_run,"*"), force = TRUE)

# get the rgb image, chm and training data 
url <- "https://github.com/gisma/gismaData/raw/master/uavRst/data/tutorial.zip"
res <- curl::curl_download(url, paste0(path_run,"tutorial.zip"))
utils::unzip(zipfile = res, exdir = unzip_path_run)

# create the links to the GI software
giLinks<-uavRst::get_gi()
saga<-linkSAGA(ver_select = T)
otb<-linkOTB()
env<-RSAGA::rsaga.env(path = saga$sagaPath)


demFileName <- Sys.glob(paths = paste0(path_run,"chm*","tif"))[1]
rdem<-raster::raster( demFileName)
raster::writeRaster(rdem,paste0(path_run,"SAGA_dem.sdat"),overwrite = TRUE,NAflag = 0)

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
                          show.output.on.console = FALSE, invisible = TRUE,
                          env = env)

RSAGA::rsaga.geoprocessor(lib = "ta_morphometry", module = 28,
                          param = list(DEM = paste(path_run,"SAGA_dem.sgrd", sep = ""), 
                                       SCALE_MIN = 1,
                                       SCALE_MAX = 8,
                                       SCALE_NUM = 2,
                                       TPI = paste(path_run,"MTPI.sgrd", sep = "")),
                          show.output.on.console = FALSE,invisible = TRUE,
                          env = env)

raster::plot(raster::raster(paste(path_run,"MTPI.sdat", sep = "")))      


command<-paste0(otb$pathOTB,"otbcli_LocalStatisticExtraction")
command<-paste(command, " -in ", demFileName )
command<-paste(command, " -channel ", 1)
command<-paste(command, " -out ", paste0(path_run,"otb_stat.tif"))
command<-paste(command, " -radius ",15)
system(command,intern = TRUE,ignore.stdout = TRUE,show.output.on.console = FALSE) 
raster::plot(raster::raster(paste0(path_run,"otb_stat.tif")))
