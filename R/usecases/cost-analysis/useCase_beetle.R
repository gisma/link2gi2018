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



# initialize the GRASS SAGA and extent settings

baseRaster<-path.expand(paste0(file.path(projRootDir),"/dem.tif"))



link2GI::linkGRASS7(x = baseRaster, 
                    gisdbase = projRootDir,
                    location = "cost") 


# import DEM to GRASS
rgrass7::execGRASS('r.external',
                   flags=c('o',"overwrite","quiet"),
                   input=baseRaster , #mosaicSRTM@file@name,
                   output='dem',
                   band=1
)
if (tci) {
  # The Topographic Convergence Index (TCI) provides an estimation
  # of rainwater runoff availability to plants based on specific catchment
  # area (A) and local slope (b) such that TCI = ln(A/tan b) (Beven & Kirkby, 1979)
  # this seems so be most suitable for the beetles
  ### terraflow provides all basic parameters of an hydrological coorrected DEM
  cat("\nTopographic Convergence Index (Beven & Kirkby, 1979) is used.\n
ln[A/tan(slope)],\n A= upslope contributing area\n\n
NOTE: be patient it is TIME CONSUMING!\n")
  
  rgrass7::execGRASS('r.terraflow',
                     flags=c("overwrite"),
                     elevation="dem",
                     filled="filled",
                     direction="accudir",
                     swatershed="watershed",
                     accumulation="accu",
                     tci="tci",
                     memory=memSize,
                     stats="demstats.txt")
}
# call costnanalysis
bd<-runBeetle(rootDir = "~/proj/beetle" ,
              inputData = beetleLocs, 
              walk=TRUE,
              costType="dem",
              baseRaster = baseRaster)
