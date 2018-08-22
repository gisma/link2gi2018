#'The phylogenetic spreading of the tibetan carabidae seems to be
#'correlated to valley linkage and available humidity. Long term humidity is
#'bound to precipitation and morphometry. It is obvious that the estimation of
#'spreeading speed and range is in no case a simple euclidian one. any cost analysis will
#'provide a better first guess especially if using a friction layer dealing with humidity and terrain
#'Assuming that the spread is following natural lines of wetness e.g. valleys, humidity
#'gradients...whatever  I'am not a beetle ask the beetle.
#'
#'@references Schmidt J, Böhner J, Brandl R, Opgenoorth L (2017) 
#'Mass elevation and lee effects markedly lift the elevational distribution
#' of ground beetles in the Himalaya-Tibet orogen. PLoS ONE 12(3): e0172939. 
#' \href{https://doi.org/10.1371/journal.pone.0172939#'guy}.

cat("setting arguments loading libs and data\n")
require(raster)
require(sp)
require(gdalUtils)
require(rgdal)

### define arguments
## project root directory
projRootDir = "~/proj/beetlespread"

# project folder
if (Sys.info()["sysname"] == "Windows"){
  projRootDir<-"C:/Users/User/Documents/proj/tutorials/link2GI2018/cost-analysis"
} else {
  projRootDir<-"~/proj/tutorials/link2GI2018/cost-analysis"
}

## define costType
costType<- "tci"

##--link2GI-- create project folder structure, NOTE the tailing slash is obligate
link2GI::initProj(projRootDir = projRootDir, 
                  projFolders =  c("run/","src/","data/"),
                  global = TRUE,
                  path_prefix ="path_ca_" )

## source functions
source(paste0(path_ca_src,"gCost.R"))

### get beetle localities and clean it up for a least path and random walk cost analysis
## read beetle positions
beetleLocs = read.csv2(paste0(path_ca_data,"beetle.csv"),header = TRUE,sep = ',',dec = '.',stringsAsFactors=FALSE)

# drop all attributes except lon lat
keeps  =  c("lon","lat")
beetleLocs = beetleLocs[keeps]

# make it spatial
coordinates(beetleLocs) =  ~lon+lat
proj4string(beetleLocs) =  CRS("+proj=longlat +datum=WGS84")

# get extent for data retrieval
xtent = extent(beetleLocs)

# remove duplicate locations
uniqueBeetleLocations  = remove.duplicates(beetleLocs, zero = 0.0, remove.second = TRUE, memcmp = TRUE)

# sort locations by longitude
uniqueBeetleLocations= uniqueBeetleLocations[order(uniqueBeetleLocations$lon, decreasing=TRUE),]
cat ("dataframe cleaned and converted\n")


## assign the DEM data setinitialize the GRASS SAGA and extent settings
baseRaster = path.expand(paste0(path_ca_data,"/dem.tif"))

##--link2GI-- linking GRASS project structure using the information from the DEM raster
link2GI::linkGRASS7(x = baseRaster, 
                    gisdbase = projRootDir,
                    location = "cost") 

# import DEM to GRASS
rgrass7::execGRASS('r.external',
                   flags=c('o',"overwrite","quiet"),
                   input=baseRaster, 
                   output='dem',
                   band=1
)


# The Topographic Convergence Index (TCI) provides an estimation
# of rainwater runoff availability to plants based on specific catchment
# area (A) and local slope (b) such that TCI = ln(A/tan b) (Beven & Kirkby, 1979)
# this seems so be most suitable for the beetles
### terraflow provides all basic parameters of an hydrological coorrected DEM
### TODO accumulated flows (costs) vs. tci  up to now tci is used for walk and accu for drain
cat("
    ########## starting r.terraflow   ###########
    
    By default the  Topographic Convergence Index (Beven & Kirkby, 1979) is used.
    ln[A/tan(slope)], A= upslope contributing area
    NOTE: be patient it is TIME CONSUMING!\n")

rgrass7::execGRASS('r.terraflow',
                   flags=c("overwrite"),
                   elevation="dem",
                   filled="filled",
                   direction="accudir",
                   swatershed="watershed",
                   accumulation="accu",
                   tci="tci",
                   memory=8000,
                   stats="demstats.txt")


# put the beetle locations coordinates into a list  
allP<-list()
for (i in seq(1,nrow(uniqueBeetleLocations@coords)) ){
  allP[[i]]<-   c(uniqueBeetleLocations$lon[i],uniqueBeetleLocations$lat[i])
}

### prepare cost raster. basically the input dataset as calculated by r.terraflow
### is used and will be subsequently scaled to avoid negative valiues
### it can be a generic DEM, aTopographic Convergence Index (TCI)
### or a hydrologically filled DEM
# forks in cost types NOTE all will be accumulated in gcost
if (costType == "tci"){
  cat('Topographic Convergence Index (TCI) is used as cost raster\n')
  offset<- getMinMaxG('tci')[2]
  rgrass7::execGRASS('r.mapcalc',
                     flags=c("overwrite"),
                     expression=paste('"tci_cost = (tci * -1) + ',offset,'"'))
  costRaster<-"tci_cost"
} else if (costType == "dem"){
  cat('original DEM is used as cost raster\n')
  offset<- getMinMaxG('dem')[2]
  rgrass7::execGRASS('r.mapcalc',
                     flags=c("overwrite"),
                     expression=paste('"dem_cost = (filled * -1) + ',offset,'"'))
  costRaster<-"dem_cost"
}else if (costType == "demfilled"){
  cat('hydrologically corrected DEM is used as cost raster\n')
  offset<- getMinMaxG('filled')[2]
  rgrass7::execGRASS('r.mapcalc',
                     flags=c("overwrite"),
                     expression=paste('"filled_cost = (filled * -1) + ',offset,'"'))
  costRaster<-"filled_cost"
}

# calulate for each point a accumulated cost raster

costDist<-list()
for (i in seq(1,length(allP))){
  startP<-allP[i]
  cat ('calculate accumulated costs for point:',unlist(startP),"\n")
  rgrass7::execGRASS("r.cost",
                     flags=c("overwrite","quiet"),
                     parameters=list(input = costRaster,
                                     outdir="accudir",
                                     output="accu",
                                     start_coordinates = as.numeric(unlist(startP)),
                                     memory=8000)
  )
  
  
  cat ('calculate walk cost for point:',unlist(startP),"\n")
  rgrass7::execGRASS("r.walk",
                     flags=c("overwrite","quiet"),
                     elevation="dem",
                     friction=costRaster,
                     outdir="walkdir",
                     output="walk",
                     start_coordinates=as.numeric(unlist(startP)),
                     lambda=0.5
  )
  
  
  # gather costs for all correspondingstP< start locations
  restP<-(allP[-i])
  costDist[[i]]<-gcost(path_ca_run,startP,restP)
}
    

#mapview::mapview(costDist[[1]])
cat('Thats it')

print(costDist)

mergedCostDist = Reduce(function(...) merge(..., all=T), costDist)


