#' Microclimate Data


cat("setting arguments loading libs and data\n")
require(link2GI)
require(raster)
require(rgrass7)

### define arguments
## project root directory

if (Sys.info()["sysname"] == "Windows"){
  projRootDir<-"C:/Users/User/Documents/proj/tutorials/link2giI2018/grassreload/"
} else {
  projRootDir<-"~/proj/tutorials/link2gi2018/grassreload/"
}



##--link2GI-- create project folder structure, NOTE the tailing slash is obligate
link2GI::initProj(projRootDir = projRootDir, 
                  projFolders =  c("run/","src/","grassdata/","geodata/"),
                  global = TRUE,
                  path_prefix ="path_gr_" )

##--link2GI-- linking GRASS project structure using the information from the DEM raster
link2GI::linkGRASS7(gisdbase = path_gr_grassdata,
                    location = "ecad17_ll",
                    gisdbase_exist = TRUE) 

# Add the mapset "ecad17" to the search path
system("g.mapsets mapset=ecad17 operation=add")+
system("g.mapsets mapset=user1 operation=add")
system("g.mapsets -p")

## download the tutorial data set 
download <- curl::curl_download("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip",
                           paste0(path_gr_run,"ne_10m_admin_0_countries.zip"))
utils::unzip(zipfile = download, exdir = path_gr_geodata)

# import and check/fix topology
system(paste0("v.import --overwrite input=",
              paste0(path_gr_geodata,"ne_10m_admin_0_countries.shp"),
              " output=country_boundaries"))

# add some metadata
system('v.support country_boundaries comment="Source: http://www.naturalearthdata.com/downloads/110m-cultural-vectors/"')
system('v.support country_boundaries map_name="Admin0 boundaries from NaturalEarthData.com"')

# show attibute table colums
system("v.info -c country_boundaries")


##--rgrass7-- import DEM to GRASS
rgrass7::execGRASS('r.in.gdal',
                   flags=c('o',"overwrite","quiet"),
                   input=path.expand(paste0(path_gr_geodata,"ecad_v17/elev_v17.tif")), 
                   output='elev_v17',
                   band=1
)

system("r.colors map=elev_v17 color=elevation")
##--rgrass7-- 
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
stat