#'@name gcost
#'@title calculates the least cost distance using an existing cost raster.
#'
#'@description
#' least cost path algorithm are useful for al lot of applications. \link{gdistance} is providing a generic R-ish approach that is cool for smaller data set. If you want to go bigger than 2000*2000 pixel than you should engage something else. This implementation uses the incredible power of GRASS 7. It calculates the least cost pathes for a set of given points for each point in the list to all other points.
#'
#'@usage gcost(path_run,currentP,allP)
#'
#'@author Chris Reudenbach
#'
#'
#'@param path_run the choosen working directory
#'@param currentP actual startpoint
#'@param allP list of all Points


#'@return gcost basically returns (a) dataframe with the position of startpoint,destination point and distance. Additionally it writes a shapefile containing all pathes to the destinations for the source point
#'
#'
#'@export gcost
#'@examples
#'#### Example to use gcost for a common analysis of the
#'     estimated spreading distances of an specifified area
#'
#' #
#' gcost(rootDir = "/home/creu/proj/beetle/cost",c("91.52", "30.62"),c("91.28" ,"30.1"))
#'
gcost<- function(path_run,currentP,allP){
  #for each point calculate costraster
  #par<-list(input = "totalCost",outdir="costdir",nearest="nearest",output="cost",start_coordinates = as.numeric(startP),stop_coordinates = as.numeric(stopList),memory=8000)
  #costPar<-list(input = "totalCost",outdir="costdir",nearest="nearest",output="cost",start_coordinates = as.numeric(unlist(startP)),memory=8000)
  
  # create the file name of the current source point
  vecFn<-  as.character(unlist(currentP))
  # we need it also for output issues in a numeric version
  vecFnNumeric<-vecFn
  vecFn<-gsub("[.]","_",vecFn)
  vecFn<-paste0(vecFn[1],"_",vecFn[2])
  
  # calculate accumulated cost, direction, nearest point from existing cost raster named "total cost"
  cat("iterate all points for Lon/Lat:",vecFnNumeric,"\n")
  
  df=NULL
  
  # with the accumulated costs of point[i] do for each other point in the list a least cost path analysis
  for (j in seq(1,length(allP)) ){
    
    endPName<-  as.character(unlist(allP[j]))
    
    eucDist<-pointDistance(unlist(currentP),unlist(allP[j]),lonlat=TRUE)
    
    
    # calculate least cost path
    rgrass7::execGRASS("r.drain",
                       flags=c("d","overwrite","quiet"),
                       input="walk",
                       direction="walkdir",
                       output="walkdrain",
                       start_coordinates=as.numeric(unlist(allP[j]))
    )
    
    # calculate least cost path
    rgrass7::execGRASS("r.drain",
                       flags=c("d","overwrite","quiet"),
                       input="accu",
                       direction="accudir",
                       output="drain",
                       start_coordinates=as.numeric(unlist(allP[j]))
    )
    
    
    cat("+ lcp from Lon/Lat:",vecFnNumeric,"to LON/LAT:", unlist(allP[j]),"\n")
    cat("++ isotropic cost surface\n")
    costDist<-getCosts("drain",vecFn,eucDist,j,endPName)
    cat("++ anisotropic cost surface\n")
    walkDist<-getCosts("walkdrain",vecFn,eucDist,j,endPName)
    # put all togheter in  a dataframe
    df<-rbind(df,data.frame(as.numeric(vecFnNumeric[1]),
                            as.numeric(vecFnNumeric[2]),
                            as.numeric(endPName[1]),
                            as.numeric(endPName[2]),
                            as.numeric(costDist),
                            as.numeric(eucDist),
                            as.numeric(walkDist)))
    
  }
  
  # write the all-pathes-of-one-point shape
  cat("write all-pathes-shape:",paste0(path_run,"/drain_",vecFn),"\n")
  rgrass7::execGRASS("v.out.ogr",
                     flags=c("overwrite","quiet"),
                     input=paste0("drain_",vecFn),
                     type="line",
                     format="ESRI_Shapefile",
                     output=paste0(path_run,"/drain_",vecFn,".shp")
  )
  
  cat("write all-pathes-shape:",paste0(path_run,"/walkdrain_",vecFn),"\n")
  rgrass7::execGRASS("v.out.ogr",
                     flags=c("overwrite","quiet"),
                     input=paste0("walkdrain_",vecFn),
                     type="line",
                     format="ESRI_Shapefile",
                     output=paste0(path_run,"/walkdrain_",vecFn,".shp")
                     
  )
  #return distances of point[i]
  colnames(df)<-c("sLon","sLat","dLon","dLat","costDist","eucDist","walkDist")
  return(df)
}

#######################################################################

getCosts <- function (inCost,vecFn,eucDist,j,endPName) {
# sampling the costs using v.report
# needs quite some addional GRASS functions 
# 1) thining  the raster to a one pixel wide raster vector   
# 2) convert it to a vector  
# 3) getting the distance
# 4) add the distance values to a table and merge it to a GRASS vecot   
  rgrass7::execGRASS("r.thin",
                     flags=c("overwrite","quiet"),
                     input=inCost,
                     output=paste0(inCost,"_thin")
  )
  
  # convert it to a vector
  rgrass7::execGRASS("r.to.vect",
                     flags=c("s","overwrite","quiet"),
                     input=paste0(inCost,"_thin"),
                     output=paste0(inCost,"_",vecFn),
                     type="line"
  )
  
  
  
  # calculate the distance of the current map
  costDist<-rgrass7::execGRASS("v.report",
                               map=paste0(inCost,"_",vecFn),
                               option="length",
                               units="meters", intern=TRUE
  )
  
  # split the distance output and extract the value
  costDist<- unlist(strsplit(costDist[2], split='||', fixed=TRUE))[2]
  
  
  rgrass7::execGRASS("v.db.addcolumn",
                     flags=c("quiet"),
                     map=paste0(inCost,"_",vecFn),
                     columns=paste(inCost," double precision,eucDist double precision")
  )
  
  rgrass7::execGRASS("v.category",
                     flags=c("overwrite","quiet"),
                     input=paste0(inCost,"_",vecFn),
                     output="merge",
                     option="sum",
                     cat=j
  )
  
  rgrass7::execGRASS("v.to.db",
                     flags=c("quiet"),
                     map=paste0(inCost,"_",vecFn),
                     option="length",
                     type="line",
                     columns=inCost,
                     units="me"
  )
  
  rgrass7::execGRASS("v.db.update",
                     flags=c("quiet"),
                     map=paste0(inCost,"_",vecFn),
                     column="label",
                     value=paste0("'",endPName[1],"|",endPName[2],"'")
  )
  rgrass7::execGRASS("v.db.update",
                     flags=c("quiet"),
                     map=paste0(inCost,"_",vecFn),
                     column="eucDist",
                     value=as.character(eucDist)
  )
  
  
  # append current line to the all-line-map
  rgrass7::execGRASS("v.patch",
                     flags=c("a","overwrite","e","quiet"),
                     input="merge",
                     output=paste0(inCost,"_",vecFn)
  )
  
  return(costDist)
}

getMinMaxG <- function (layer=NULL){
  r.info<-rgrass7::execGRASS('r.info', flags=c("r","quiet"), map=layer,intern=TRUE)
  min <- as.numeric(unlist(strsplit(r.info[1], split='=', fixed=TRUE))[2])
  max <- as.numeric(unlist(strsplit(r.info[2], split='=', fixed=TRUE))[2])
  return(c(min,max))
  
}