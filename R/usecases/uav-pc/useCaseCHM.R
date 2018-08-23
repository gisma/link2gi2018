# Crown Segmentation
# -------------------
#   
#   The reliable and reproducible segmentation of tree entities also called tree crowns is the basic need for all individual based determination of structure, competition ecological traits and so on. While this kind of segmentation is even hard in real live there are tons of approaches to perform it on LiDAR data. It is crucial to understand that only high end terrestrial 3D scanning together with terrestrial LiDAR will provide reliable data for doing so. Nevertheless let's try. We have to keep in mind that UAV data is not *really* 3D because you will find only a small vertical variation in the height of retrieved point in a column. Due to this we are not able to use the well known LiDAR Segmentation approaches on 3D data. We have to rely on a canopy height model (CHM)
# 
# Canopy Height Models
# --------------------
# 
# Canopy Height Models (CHM) are usually derived from airborne LiDAR data. Since they are rasterized, they can be comprehended as an aggregated simplification of the 3D point cloud model.They are typically representing the **tree** canopy. A reliable CHM has removed all other above-ground features such as buildings etc.
# 
# Even using LiDAR data there are some massive limitations with the most CHMs. Same and even worse with UAV 3D point clouds. Nevertheless CHMs are very useful for all kind of forest and ecological management, for conservation biology and a lot of other topics.
# 
# The aim of this short tutorial is to show some possibilities to do so.
# To derive Orthoimages or point clouds one can use between different tools the tutorial data is produced using [Agisoft Photoscan](http://www.agisoft.com) which is a great tool for deriving point clouds and all kind of surface models. In the end of the processing chain you will have an orthorectified image and a dense point cloud. We will use some UAV data from the Marburg Open Forest project.

devtools::install_github("gisma/link2GI", ref = "master")
devtools::install_github("gisma/uavRst", ref = "master")
require(uavRst)
require(raster)
require(link2GI)

# proj subfolders
projRootDir<-getwd()
#setwd(paste0(projRootDir,"run"))

paths<-link2GI::initProj(projRootDir = projRootDir,
                         projFolders = c("data/","data/ref/","output/","run/","las/"),
                         global = TRUE,
                         path_prefix = "path_")

# get some colors
pal = mapview::mapviewPalette("mapviewTopoColors")

# get the data
url <- "https://github.com/gisma/gismaData/raw/master/uavRst/data/lidar.las"
res <- curl::curl_download(url, paste0(path_data,"lasdata.las"))
# make the folders and linkages
giLinks<-uavRst::get_gi()

# create 2D point cloud DTM
dtm <- uavRst::pc2D_dtm(laspcFile = paste0(path_data,"lasdata.las"),
                gisdbasePath = projRootDir,
                tension = 20 ,
                sampleGridSize = 25,
                targetGridSize = 0.5,
                giLinks = giLinks)
dsm <- uavRst::pc2D_dsm(laspcFile = paste0(path_data,"lasdata.las"),
                gisdbasePath = projRootDir,
                sampleMethod = "max",
                targetGridSize = 0.5, 
                giLinks = giLinks)
mapview::mapview(dsm-dtm,col.regions=pal)