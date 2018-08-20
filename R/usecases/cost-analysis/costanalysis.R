#'@name runBeetle
#'@title Wrapper function to analyse the phylogenetic spread of running beetle
#'  via a cost analysis based on morphometry and derived potential surface wetness.
#'
#'@description The phylogenetic spreading of the tibetan carabidae seems to be
#'correlated to valley linkage and available humidity. Long term humidity is
#'bound to precipitation and morphometry. It is obvious that the estimation of
#'spreeading speed and range is in no case a simple euclidian one. runBeetle
#'provides a first better estimation using a cost or friction analysis assuming
#'that the spread is following natural lines of wetness e.g. valleys, humidity
#'gradients...whatever  I'am not a beetle ask the beetle
#'\href{http://www.zoologie.uni-rostock.de/mitarbeiter/joachimschmidt/joachimschmidtpubl}{beetle
#'guy}.
#'
#'@usage runBeetle(rootDir,workingDir="cost",inputData=NULL,costType="tci",
#'  baseRaster=NULL,internalCost=TRUE)

#'
#'@author Chris Reudenbach
#' \cr
#' \emph{Maintainer:} Chris Reudenbach \email{reudenbach@@uni-marburg.de}

#'
#'@references Schmidt, J., Boehner, J., Brandl, R. & Opgenoorth, L. (2017):
#'  Mass elevation and lee effect override latitudinal effects in determining
#'  the distribution ranges of species: Ground beetles from the Himalaya-Tibet
#'  Orogen. PLoS ONE, \href{https://doi.org/10.1371/journal.pone.0172939}{doi:0172939}.
#'
#' \href{https://grass.osgeo.org/grass7/}{GRASS70}
#' \href{https://sourceforge.net/projects/saga-gis/files/}{SAGA GIS}
#'
#'
#'@param rootDir  project directory\cr
#'@param workingDir working directory\cr
#'@param inputData location data containing obligatory the cols lon,lat and
#'  optional a code col. The format has to be a data frame see example.
#'@param costType used if internalCost = TRUE.  default is "tci"  you can choose
#'  "tci" "demfilled" or "dem" see details for more information
#'  @param baseRaster initial base raster for cost analysis
#'@param memSize memory in MB as used by GRASS
#'
#'@details  The core of the analysis is an isotropic/anisotropic least cost path
#'  calculation. By default the cost surface is assumed to be a local derivate
#'  of the morphometry with respect to the potential soil humidity. A perfect
#'  approch to derive such information is the use of a Digital Elevation Model
#'  DEM and some corresponding derivates as the Topographic Convergence Index.\cr
#'
#'  If you choose "tci"  (default) the cost surface provides an estimation of
#'  rainwater runoff availability to plants based on specific catchment area (A)
#'  and local slope (b) such that TCI = ln(A/tan b) (Beven & Kirkby, 1979). This
#'  seems be pretty straightforward and fairly suitable for the beetles
#'  "behaviour.\cr
#'
#'  If you chosse "dem" a typical accumulation cost grid from the original DEM
#'  will be used\cr
#'
#'  If you choose "demfilled" a typical accumulation cost grid from the
#'  hydrologically corrected DEM will be used\cr
#'
#'  For the r.walk algorithm (anisotropic costs) the non accumulated data is used.

#'@return runBeetle returns:\cr
#' dataframe with the (a) euclidian distances, (b) cost distance (isotropic cost surface) and (c) the walk distance (anisotropic cost surface)\cr
#  Additionally for each source point and cost analysis type (walk/drain) a seperate shapefile containing the same information and geometry is created
#'
#'
#'@export runBeetle
#'@examples
#'
#'\dontrun{
#'#### NOTE: You obligatory need GRASS70
#'
#' require(raster)
#' require(sp)
#' require(gdalUtils)
#' require(rgdal)
#'
#' ### read positions via a csv file
#' beetleLocs<-read.csv2("~/proj/beetle/beetle.csv",header = TRUE,sep = ',',dec = '.',stringsAsFactors=FALSE)
#' ### calculate the pathes
#' beetleDist<-runBeetle(rootDir = "~/proj/beetle" ,inputData = beetleLocs, walk=TRUE)
#' }


runBeetle <-function(rootDir,
                     workingDir="cost",
                     inputData=NULL,
                     baseRaster,
                     costType="tci",
                     walk=FALSE,
                     memSize=4000){
  
  
  
  # check if input data is correct
  if (class(inputData) == "data.frame"){
    tmp<-inputData
    
    # drop all attributes except lon lat
    keeps <- c("lon","lat")
    tmp<-tmp[keeps]
    
    # make it spatial
    coordinates(tmp)<- ~lon+lat
    proj4string(tmp)<- CRS("+proj=longlat +datum=WGS84")
    
    # get extent for data retrieval
    xtent<-extent(tmp)
    
    # remove duplicate locations
    uniqueLocations <-remove.duplicates(tmp, zero = 0.0, remove.second = TRUE, memcmp = TRUE)
    
    # sort df
    uniqueLocations<-uniqueLocations[order(uniqueLocations$lon, decreasing=TRUE),]
    cat ("dataframe cleaned and converted\n")
  } else {stop(" you did not provide a data frame")}
  # put them into a list  
  allP<-list()
  for (i in seq(1,nrow(uniqueLocations@coords)) ){
    allP[[i]]<-   c(uniqueLocations$lon[i],uniqueLocations$lat[i])
  }
  ### end pointlist
  
  
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
    
    
    # gather costs for all corresponding start locations
    restP<-(allP[-i])
    costDist[[i]]<-gcost(path_run,startP,restP)
  }
  
  
  ### todo
  # matrix of results
  # merge with ids
  # merge geometrical infos into shapes
  #mapview::mapview(costDist[[1]])
  cat('Thats it')
  mergedCostDist = Reduce(function(...) merge(..., all=T), costDist)
  return(mergedCostDist)
}


