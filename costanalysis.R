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
#'  "tci" "dem.filled" or "accu" see details for more information
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
#'  If you chosse "accu" a typical accumulation cost grid from the original DEM
#'  will be used\cr
#'
#'  If you choose "dem.filled" a typical accumulation cost grid from the
#'  hydrologically corrected DEM will be used\cr
#'
#'  For the r.walk algorithm the non accumulated data is used.

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
#' require(doParallel)
#' require(foreach)
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
  
  allP<-list()
  # fill it with starting points better
  for (i in seq(1,length(tmp$lon)) ){
    allP[[i]]<-   !is.na(c(uniqueLocations$lon[i],uniqueLocations$lat[i]))
  }
  ### end pointlist


    # import DEM to GRASS
    rgrass7::execGRASS('r.external',
                       flags=c('o',"overwrite","quiet"),
                       input=baseRaster , #mosaicSRTM@file@name,
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
        
By default the  Topographic Convergence Index (Beven & Kirkby, 1979) is used.\n
ln[A/tan(slope)],\n A= upslope contributing area\n\n
NOTE: be patient even if massive optimized it is TIME CONSUMING!\n")
    
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
    # forks in cost types NOTE all will be accumulated in gcost
    if (costType == "tci"){
      cat('TCI is assumed to be costLayer')
      offset<- getMinMaxG('tci')[2]
      rgrass7::execGRASS('r.mapcalc',
                         flags=c("overwrite"),
                         expression=paste('"cost = (tci * -1) + ',offset,'"'))
    } else if (costType == "dem"){
      cat('dem.filled is assumed to be costLayer')
      offset<- getMinMaxG('filled')[2]
      rgrass7::execGRASS('r.mapcalc',
                         flags=c("overwrite"),
                         expression=paste('"cost = (filled * -1) + ',offset,'"'))
    }
    

  

  ##### Main loop
  # calulate for each point a accumulated cost raster
  # NOTE the used data is totalcost from above!!!
  
  
  #lst_all <- foreach(i = 1:ceiling(length(allP)*0.5)) %dopar% {
  #costDistTmp<-data.frame(num=rep(NA, 5), txt=rep("", 5), stringsAsFactors=FALSE)
  costDist<-list()
  for (i in seq(1,length(allP))){
    startP<-allP[i]
    allP<-allP[-i]
    if (!is.null(unlist(startP))){
      accuCalc(currentP=startP,memory=memSize,dump=dump,walk=walk)
      costDist[[i]]<-gcost(path_run,startP,allP)
    }
  }
  
  
  ### todo
  # matrix of results
  # merge with ids
  # merge geometrical infos into shapes

  #dem + point<-mapview(pointList)
  
  
  cat('Thats it')
  mergedCostDist = Reduce(function(...) merge(..., all=T), costDist)
  return(mergedCostDist)
}


