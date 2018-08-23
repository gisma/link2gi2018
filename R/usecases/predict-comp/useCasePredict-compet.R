#' Prediction compettion

cat("setting arguments loading libs and data\n")
require(raster)
require(uavRst)
require(gdalUtils)
require(rgdal)

### define arguments

# project folder
if (Sys.info()["sysname"] == "Windows"){
  projRootDir<-"C:/Users/User/Documents/proj/tutorials/link2gi2018predict-compet"
} else {
  projRootDir<-"~/proj/tutorials/link2gi2018/predict-compet"
}

##--link2GI-- create project folder structure, NOTE the tailing slash is obligate
link2GI::initProj(projRootDir = projRootDir, 
                  projFolders =  c("run/","src/","data/"),
                  global = TRUE,
                  path_prefix ="path_pc_" )

## define filenames used
fnDEM = path.expand(paste0(path_pc_data,"/DEM_5m.tif"))
fnFT = path.expand(paste0(path_pc_data,"/Forest_types_10m.tif"))
l8_1 = path.expand(paste0(path_pc_data,"/LC08_L1TP_191025_20130727_20170503_01_T1_sr_band1.tif"))
l8_2 = path.expand(paste0(path_pc_data,"/LC08_L1TP_191025_20130727_20170503_01_T1_sr_band2.tif"))
l8_3 = path.expand(paste0(path_pc_data,"/LC08_L1TP_191025_20130727_20170503_01_T1_sr_band3.tif"))

# read original raster data
 rdem<- raster::raster(fnDEM)
 rft<- raster::raster(fnFT)
 # resample dtm and rgb to dsm 
 dem10 <- raster::resample(rdem, rft , method = 'bilinear')
 raster::writeRaster(dem10 ,paste0(path_pc_data,"/dem_10m_c.tif"))

# # crop reproject satellite data
 l8_1p <- gdalwarp(srcfile =l8_1, dstfile = path.expand(paste0(path_pc_data,"/LC08__band1_p.tif")), 
                   overwrite = TRUE,  
                   t_srs = "+proj=krovak +lat_0=49.5 +lon_0=24.83333333333333 +k=0.9999 +x_0=0 +y_0=0 +ellps=bessel +towgs84=589,76,480,0,0,0,0 +units=m +no_defs",
                   output_Raster = TRUE )  
 l8_2p <- gdalwarp(srcfile =l8_2, dstfile = path.expand(paste0(path_pc_data,"/LC08__band2_p.tif")), 
                   overwrite = TRUE,  
                   t_srs = "+proj=krovak +lat_0=49.5 +lon_0=24.83333333333333 +k=0.9999 +x_0=0 +y_0=0 +ellps=bessel +towgs84=589,76,480,0,0,0,0 +units=m +no_defs",
                   output_Raster = TRUE ) 
 l8_3p <- gdalwarp(srcfile =l8_3, dstfile = path.expand(paste0(path_pc_data,"/LC08__band3_p.tif")), 
                   overwrite = TRUE,  
                   t_srs = "+proj=krovak +lat_0=49.5 +lon_0=24.83333333333333 +k=0.9999 +x_0=0 +y_0=0 +ellps=bessel +towgs84=589,76,480,0,0,0,0 +units=m +no_defs",
                   output_Raster = TRUE ) 
 # crop satellite data
rl8_1 <- raster::crop(l8_1p,rdem)
rl8_2 <- raster::crop(l8_3p,rdem)
rl8_3 <- raster::crop(l8_3p,rdem)

# calculate some indices
rgbi<-uavRst::rgb_indices(rl8_1,rl8_2,rl8_3,c("VARI", "NDTI", "RI",
                                        "SCI", "BI", "SI", "HI", "TGI", "GLI", "NGRDI", "GRVI", "GLAI",
                                        "CI"))
# resample result to the 10 m resolution
rgbi10 <- raster::resample(rgbi, rft , method = 'bilinear')

# stack results so far
predictors<-stack(rgbi10,dem10)

# write it on storage
raster::writeRaster(dem10,paste0(path_pc_run,"/dem_10m_c.tif"),overwrite=TRUE)
raster::writeRaster(dem10,paste0(path_pc_run,"dem_10m_c.sdat"),overwrite = TRUE,NAflag = 0) 

##--link2GI-- linking GRASS project structure using the information from the DEM raster
link2GI::linkGRASS7(x = dem ,
                    gisdbase = projRootDir,
                    location = "spatcomp") 
# link SAGA
saga<-linkSAGA()

# import DEM to GRASS
rgrass7::execGRASS('r.in.gdal',
                   flags=c('o',"overwrite","quiet"),
                   input=paste0(path_pc_run,"/dem_10m_c.tif"), 
                   output='dem10'
)


# The Topographic Convergence Index (TCI) provides an estimation
# of rainwater runoff availability to plants based on specific catchment
# area (A) and local slope (b) such that TCI = ln(A/tan b) (Beven & Kirkby, 1979)

rgrass7::execGRASS('r.terraflow',
                   flags=c("overwrite"),
                   elevation="dem10",
                   direction="accudir",
                   swatershed="watershed",
                   tci="tci",
                   memory=8000,
                   stats="demstats.txt")
# read and stack results
tci<-raster::raster(rgrass7::readRAST("tci"))
predictors<-stack(predictors,tci)
watershed<-raster::raster(rgrass7::readRAST("watershed"))
predictors<-stack(predictors,watershed)

# call saga general terrain analysis
system(paste0(saga$sagaCmd,' ta_compound  0', paste0(" -ELEVATION=",paste0(path_pc_run),"dem_10m_c.sgrd "),
                                 paste0(" -SLOPE=",paste0(path_pc_run),"slope.sgrd "),
                                 paste0(" -ASPECT=",paste0(path_pc_run),"aspect.sgrd "),
                                 paste0(" -CONVERGENCE=",paste0(path_pc_run),"convergence.sgrd "),
                                 paste0(" -WETNESS=",paste0(path_pc_run),"wetness.sgrd "),
                                 paste0(" -LSFACTOR=",paste0(path_pc_run),"lsfactor.sgrd "),
                                 paste0(" -VALL_DEPTH=",paste0(path_pc_run),"vall_depth.sgrd")))

# read and stack results
slope<-raster::raster(paste0(path_pc_run,"/slope.sdat"))
predictors<-stack(predictors,slope)
aspect<-raster::raster(paste0(path_pc_run,"/aspect.sdat"))
predictors<-stack(predictors,aspect)
convergence<-raster::raster(paste0(path_pc_run,"/convergence.sdat"))
predictors<-stack(predictors,convergence)
wetness<-raster::raster(paste0(path_pc_run,"/wetness.sdat"))
predictors<-stack(predictors,wetness)
lsf<-raster::raster(paste0(path_pc_run,"/lsfactor.sdat"))
predictors<-stack(predictors,lsf)
valld<-raster::raster(paste0(path_pc_run,"/vall_depth.sdat"))
predictors<-stack(predictors,valld)

# save stack
raster::writeRaster(predictors,paste0(path_pc_run,"/predictor_sp.grd"),overwrite=TRUE)
