#' Microclimate Data


cat("setting arguments loading libs and data\n")
require(raster)
require(uavRst)
require(sp)
require(gdalUtils)
require(rgdal)

### define arguments
## project root directory

if (Sys.info()["sysname"] == "Windows"){
  projRootDir<-"C:/Users/User/Documents/proj/tutorials/grassreload/"
} else {
  projRootDir<-"~/proj/tutorials/geostat18/grassreload/"
}



##--link2GI-- create project folder structure, NOTE the tailing slash is obligate
link2GI::initProj(projRootDir = projRootDir, 
                  projFolders =  c("run/","src/","grassdata/","geodata/"),
                  global = TRUE,
                  path_prefix ="path_" )

## source functions
#source(paste0(path_src,"gCost.R"))

### get beetle localities and clean it up for a least path and random walk cost analysis
## read beetle positions
#beetleLocs = read.csv2(paste0(path_data,"beetle.csv"),header = TRUE,sep = ',',dec = '.',stringsAsFactors=FALSE)
# 
# # drop all attributes except lon lat
# keeps  =  c("lon","lat")
# beetleLocs = beetleLocs[keeps]
# 
# # make it spatial
# coordinates(beetleLocs) =  ~lon+lat
# proj4string(beetleLocs) =  CRS("+proj=longlat +datum=WGS84")
# 
# # get extent for data retrieval
# xtent = extent(beetleLocs)
# 
# # remove duplicate locations
# uniqueBeetleLocations  = remove.duplicates(beetleLocs, zero = 0.0, remove.second = TRUE, memcmp = TRUE)
# 
# # sort locations by longitude
# uniqueBeetleLocations= uniqueBeetleLocations[order(uniqueBeetleLocations$lon, decreasing=TRUE),]
# cat ("dataframe cleaned and converted\n")
# # 

## assign the DEM data setinitialize the GRASS SAGA and extent settings
fnDEM = path.expand(paste0(path_grassdata,"ecad_v17/elev_v17.tif"))


##--link2GI-- linking GRASS project structure using the information from the DEM raster
link2GI::linkGRASS7(gisdbase = path_grassdata,
                    location = "ecad17_ll",
                    gisdbase_exist = TRUE) 

# Add the mapset "ecad17" to the search path
system("g.mapsets mapset=ecad17 operation=add")+
system("g.mapsets mapset=user1 operation=add")
system("g.mapsets -p")

## download the tutorial data set 
download <- curl::curl_download("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip",
                           paste0(path_run,"ne_10m_admin_0_countries.zip"))
utils::unzip(zipfile = download, exdir = path_geodata)

# import and check/fix topology
system(paste0("v.import --overwrite input=",
              paste0(path_geodata,"ne_10m_admin_0_countries.shp"),
              " output=country_boundaries"))

# add some metadata
system('v.support country_boundaries comment="Source: http://www.naturalearthdata.com/downloads/110m-cultural-vectors/"')
system('v.support country_boundaries map_name="Admin0 boundaries from NaturalEarthData.com"')

# show attibute table colums
system("v.info -c country_boundaries")


# import DEM to GRASS
rgrass7::execGRASS('r.in.gdal',
                   flags=c('o',"overwrite","quiet"),
                   input=path.expand(paste0(path_geodata,"ecad_v17/elev_v17.tif")), 
                   output='elev_v17',
                   band=1
)

system("r.colors map=elev_v17 color=elevation")
rgrass7::execGRASS(cmd = "g.region", raster="precip.1951_1980.01.sum@ecad17")
system("g.region raster=precip.1951_1980.01.sum@ecad17",ignore.stdout = FALSE)
system('r.series --overwrite input=`g.list rast pattern="precip.1981_2010.*.sum" sep="comma"` output=precip.1981_2010.annual.sum method=sum
')
system('r.series --overwrite input=`g.list rast pattern="tmean.1981_2010.*.avg" sep="comma"` output=tmean.1981_2010.annual.avg method=average
')

precip.1981_2010.annual.sum<-raster::raster(rgrass7::readRAST("precip.1981_2010.annual.sum"))
tmean.1981_2010.annual.avg<-raster::raster(rgrass7::readRAST("tmean.1981_2010.annual.avg"))

mapview::mapview(precip.1981_2010.annual.sum) + tmean.1981_2010.annual.avg

stat<-system2(command = "r.univar", args = 'tmean.1981_2010.annual.avg -e -g',stdout = TRUE,stderr = TRUE)
