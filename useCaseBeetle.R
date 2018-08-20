require(doParallel)
require(foreach)
require(raster)
require(sp)
require(gdalUtils)
require(rgdal)
projRootDir = "~/proj/beetle"
link2GI::initProj(projRootDir = projRootDir, 
                  projFolders =  c("run/","cost/"),
                  global = TRUE,
                  path_prefix ="path_" )

beetleLocs<-read.csv2("~/proj/beetle/beetle.csv",header = TRUE,sep = ',',dec = '.',stringsAsFactors=FALSE)



# initialize the GRASS SAGA and extent settings

baseRaster<-path.expand(paste0(file.path(projRootDir),"/dem.tif"))



link2GI::linkGRASS7(x = baseRaster, 
           gisdbase = projRootDir,
           location = "cost") 

bd<-runBeetle(rootDir = "~/proj/beetle" ,
              inputData = beetleLocs, 
              walk=TRUE,
              costType="dem",
              baseRaster = baseRaster)
