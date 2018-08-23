#' Adapting parts of the tutorial
#' https://neteler.gitlab.io/grass-gis-analysis/02_grass-gis_ecad_analysis/
#' of Marcus Neteler and Veronica Andreo
#' 
#' This usecase is just giving you an idea how quick and dirty you may 
#' integrate GRASS shell commandline code to a R script
#' Most of the comments and command lines are just copy and paste
#' from Markus Netelers tutorial script 
#' 
#' I just tried to "streamline" the code and dropped 
#' out unix specific stuff like calling displays


cat("setting arguments loading libs and data\n")
require(link2GI)
require(raster)
require(rgrass7)

### define arguments


# define root folder
if (Sys.info()["sysname"] == "Windows"){
  projRootDir<-"C:/Users/User/Documents/link2gi2018-master/grassreload"
} else {
  projRootDir<-"~/link2gi2018-master/grassreload"
}



##--link2GI-- create project folder structure, NOTE the tailing slash is obligate
link2GI::initProj(projRootDir = projRootDir, 
                  projFolders =  c("run/","src/","grassdata/","geodata/","grassdata/user1/"),
                  global = TRUE,
                  path_prefix ="path_gr_" )

## download the tutorial data set 
download <- curl::curl_download("https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_0_countries.zip",
                                paste0(path_gr_run,"ne_10m_admin_0_countries.zip"))
utils::unzip(zipfile = download, exdir = path_gr_geodata)

### 
##--link2GI-- linking GRASS project structure using the information from the DEM raster
link2GI::linkGRASS7(gisdbase = path_gr_grassdata,
                    location = "ecad17_ll",
                    gisdbase_exist = TRUE) 

#-- create mapset user1 ecad17
system("g.mapset -c mapset=user1")


# Add the mapset "ecad17" and "user1" to the search path
## please note the difference between mapset and mapsets
system("g.mapsets  mapset=user1 operation=add")
system("g.mapsets  mapset=ecad17 operation=add")
system("g.list type=rast")

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
# color it (works even if you are not looking at it)
system("r.colors map=elev_v17 color=elevation")



### finish with the basic execise

### start the anaysis

##--rgrass7-- Set the computational region to the full raster map (bbox and spatial resolution)  
# resulting in the same using a system call system("g.region raster=precip.1951_1980.01.sum@ecad17")
rgrass7::execGRASS(cmd = "g.region", raster="precip.1951_1980.01.sum")

# Now use the r.series command to create annual precip map for the period 1951 to 1980
system('r.series --overwrite input=`g.list rast pattern="precip.1981_2010.*.sum" sep="comma"` output=precip.1981_2010.annual.sum method=sum
')
# Aggregate the temperature maps average annual temperature
system('r.series --overwrite input=`g.list rast pattern="tmean.1981_2010.*.avg" sep="comma"` output=tmean.1981_2010.annual.avg method=average
')
# read results to R
a_p_sum_1981_2010<-raster::raster(rgrass7::readRAST("precip.1981_2010.annual.sum"))
a_t_mean_1981_2010<-raster::raster(rgrass7::readRAST("tmean.1981_2010.annual.avg"))

# use mapview for visualisation
mapview::mapview(a_p_sum_1981_2010) + a_t_mean_1981_2010

# Compute extended univariate statistics
stat<-system2(command = "r.univar", args = 'tmean.1981_2010.annual.avg -e -g',stdout = TRUE,stderr = TRUE)




### lets do some timeseries


########################################################################
# Commands for the TGRASS lecture at GEOSTAT Summer School in Prague
# Author: Veronica Andreo
# Date: July - August, 2018
########################################################################


########### Before the workshop (done for you in advance) ##############

# Install i.modis add-on (requires pymodis library - www.pymodis.org)
system("g.extension extension=i.modis")

############## For the workshop (what you have to do) ##################

## Download the ready to use mapset 'modis_lst' from:
## https://gitlab.com/veroandreo/grass-gis-geostat-2018
## and unzip it into North Carolina full LOCATION 'nc_spm_08_grass7'
link2GI::linkGRASS7(gisdbase = path_gr_grassdata,
                    location = "nc_spm_08_grass7",
                    gisdbase_exist = TRUE) 

system("g.mapsets  mapset=modis_lst operation=add")
# Get list of raster maps in the 'modis_lst' mapset
system("g.mapsets  -p")
system("g.mapset  mapset=modis_lst")
# Get info from one of the raster maps
system('r.info map=MOD11B3.A2015060.h11v05.single_LST_Day_6km')


## Region settings and MASK

# Set region to NC state with LST maps' resolution
system("g.region -p vector=nc_state align=MOD11B3.A2015060.h11v05.single_LST_Day_6km")

# Set a MASK to nc_state boundary
system("r.mask --overwrite vector=nc_state")

# you should see this statement in the terminal from now on
#~ [Raster MASK present]


## Time series

# Create the STRDS

system('t.create --overwrite type=strds temporaltype=absolute output=LST_Day_monthly@modis_lst title="Monthly LST Day 5.6 km" description="Monthly LST Day 5.6 km MOD11B3.006, 2015-2017"')

# Check if the STRDS is created
system("t.list type=strds")

# Get info about the STRDS
system("t.info input=LST_Day_monthly")


## Add time stamps to maps (i.e., register maps)

# in Unix systems
system('t.register -i input=LST_Day_monthly maps=`g.list type=raster pattern="MOD11B3*LST_Day*" separator=comma` start="2015-01-01" increment="1 months"')


# Check info again
system('t.info input=LST_Day_monthly')

# Check the list of maps in the STRDS
t.rast.list input=LST_Day_monthly

# Check min and max per map
system('t.rast.list input=LST_Day_monthly columns=name,min,max')


## Let's see a graphical representation of our STRDS
system('g.gui.timeline inputs=LST_Day_monthly')


## Temporal calculations: K*50 to Celsius 

# Re-scale data to degrees Celsius
# https://www.mail-archive.com/grass-user@lists.osgeo.org/msg35180.html
## Apparently the data got zstd compressed in 7.5.svn which isn't supported in
## 7.4.x. You need to switch the compression in 7.5 with r.compress.
system('t.rast.algebra --overwrite basename=LST_Day_monthly_celsius expression="LST_Day_monthly_celsius = LST_Day_monthly * 0.02 - 273.15"')

# Check info
system('t.info LST_Day_monthly_celsius')

# some new features in upcoming grass76
t.rast.algebra basename=LST_Day_monthly_celsius suffix=gran \
expression="LST_Day_monthly_celsius = LST_Day_monthly * 0.02 - 273.15"


## Time series plots

# LST time series plot for the city center of Raleigh
g.gui.tplot strds=LST_Day_monthly_celsius \
coordinates=641428.783478,229901.400746

# some new features in upcoming grass76
g.gui.tplot strds=LST_Day_monthly_celsius \
coordinates=641428.783478,229901.400746 \
title="Monthly LST. City center of Raleigh, NC " \
xlabel="Time" ylabel="LST" \
csv=raleigh_monthly_LST.csv


## Get specific lists of maps

# Maps with minimum value lower than or equal to 5
t.rast.list input=LST_Day_monthly_celsius order=min \
columns=name,start_time,min where="min <= '5.0'"

#~ name|start_time|min
#~ LST_Day_monthly_celsius_2015_02|2015-02-01 00:00:00|-1.31
#~ LST_Day_monthly_celsius_2017_01|2017-01-01 00:00:00|-0.89
#~ LST_Day_monthly_celsius_2015_01|2015-01-01 00:00:00|-0.25
#~ LST_Day_monthly_celsius_2016_01|2016-01-01 00:00:00|-0.17
#~ LST_Day_monthly_celsius_2016_02|2016-02-01 00:00:00|0.73
#~ LST_Day_monthly_celsius_2017_12|2017-12-01 00:00:00|1.69
#~ LST_Day_monthly_celsius_2016_12|2016-12-01 00:00:00|3.45

# Maps with maximum value higher than 30
t.rast.list input=LST_Day_monthly_celsius order=max \
columns=name,start_time,max where="max > '30.0'"

#~ name|start_time|max
#~ LST_Day_monthly_celsius_2017_04|2017-04-01 00:00:00|30.85
#~ LST_Day_monthly_celsius_2017_09|2017-09-01 00:00:00|32.45
#~ LST_Day_monthly_celsius_2016_05|2016-05-01 00:00:00|32.97
#~ LST_Day_monthly_celsius_2015_09|2015-09-01 00:00:00|33.49
#~ LST_Day_monthly_celsius_2017_05|2017-05-01 00:00:00|34.35
#~ LST_Day_monthly_celsius_2015_05|2015-05-01 00:00:00|34.53
#~ LST_Day_monthly_celsius_2017_08|2017-08-01 00:00:00|35.81
#~ LST_Day_monthly_celsius_2016_09|2016-09-01 00:00:00|36.33
#~ LST_Day_monthly_celsius_2016_08|2016-08-01 00:00:00|36.43

# Maps between two given dates
t.rast.list input=LST_Day_monthly_celsius columns=name,start_time \
where="start_time >= '2015-05' and start_time <= '2015-08-01 00:00:00'"

#~ name|start_time
#~ LST_Day_monthly_celsius_2015_05|2015-05-01 00:00:00
#~ LST_Day_monthly_celsius_2015_06|2015-06-01 00:00:00
#~ LST_Day_monthly_celsius_2015_07|2015-07-01 00:00:00
#~ LST_Day_monthly_celsius_2015_08|2015-08-01 00:00:00

# Maps from January
t.rast.list input=LST_Day_monthly_celsius columns=name,start_time \
where="strftime('%m', start_time)='01'"

#~ name|start_time
#~ LST_Day_monthly_celsius_2015_01|2015-01-01 00:00:00
#~ LST_Day_monthly_celsius_2016_01|2016-01-01 00:00:00
#~ LST_Day_monthly_celsius_2017_01|2017-01-01 00:00:00


## Descriptive statistics for STRDS

# Print univariate stats for maps within STRDS
t.rast.univar input=LST_Day_monthly_celsius

#~ id|start|end|mean|min|max|mean_of_abs|stddev|variance|coeff_var|sum|null_cells|cells
#~ LST_Day_monthly_celsius_2015_01@modis_lst|2015-01-01 00:00:00|2015-02-01 00:00:00|7.76419671326958|-0.25|11.89|7.76431935246506|1.77839501064634|3.1626888138918|22.905074102604|31654.6300000001|4043|8120
#~ LST_Day_monthly_celsius_2015_02@modis_lst|2015-02-01 00:00:00|2015-03-01 00:00:00|7.23198184939909|-1.30999999999995|12.37|7.23262447878345|2.05409396877013|4.21930203253782|28.4029193040744|29484.7900000001|4043|8120
#~ LST_Day_monthly_celsius_2015_03@modis_lst|2015-03-01 00:00:00|2015-04-01 00:00:00|16.0847706647044|8.27000000000004|22.0700000000001|16.0847706647044|2.22005586700676|4.92864805263112|13.8022226942802|65577.61|4043|8120
#~ LST_Day_monthly_celsius_2015_04@modis_lst|2015-04-01 00:00:00|2015-05-01 00:00:00|22.2349889624724|10.05|28.21|22.2349889624724|2.14784334478279|4.6132310337277|9.65974549574931|90652.05|4043|8120
#~ LST_Day_monthly_celsius_2015_05@modis_lst|2015-05-01 00:00:00|2015-06-01 00:00:00|26.7973632572971|16.89|34.53|26.7973632572971|2.43267997291578|5.91793185062553|9.07805723107235|109252.85|4043|8120

# Get extended statistics
t.rast.univar -e input=LST_Day_monthly_celsius

# Write the univariate stats output to a csv file
t.rast.univar input=LST_Day_monthly_celsius separator=comma \
output=stats_LST_Day_monthly_celsius.csv


## Temporal aggregations (full series)

# Get maximum LST in the STRDS
t.rast.series input=LST_Day_monthly_celsius \
output=LST_Day_max method=maximum

# Get minimum LST in the STRDS
t.rast.series input=LST_Day_monthly_celsius \
output=LST_Day_min method=minimum

# Change color pallete to celsius
r.colors map=LST_Day_min,LST_Day_max color=celsius


## Display the new maps with mapswipe and compare them to elevation

# LST_Day_max & elevation
g.gui.mapswipe first=LST_Day_max second=elev_state_500m

# LST_Day_min & elevation
g.gui.mapswipe first=LST_Day_min second=elev_state_500m


## Temporal operations with time variables

# Get month of maximum LST
t.rast.mapcalc -n inputs=LST_Day_monthly_celsius output=month_max_lst \
expression="if(LST_Day_monthly_celsius == LST_Day_max, start_month(), null())" \
basename=month_max_lst

# Get basic info
t.info month_max_lst

# Get the earliest month in which the maximum appeared (method minimum)
t.rast.series input=month_max_lst method=minimum output=max_lst_date

# Remove month_max_lst strds 
# we were only interested in the resulting aggregated map
t.remove -rf inputs=month_max_lst

# Note that the flags "-rf" force (immediate) removal of both 
# the STRDS and the maps registered in it.


## Display maps in a wx monitor

# Open a monitor
d.mon wx0

# Display the raster map
d.rast map=max_lst_date

# Display boundary vector map
d.vect map=nc_state type=boundary color=#4D4D4D width=2
  
  # Add raster legend
  d.legend -t -s raster=max_lst_date title="Month" \
title_fontsize=20 font=sans fontsize=18

# Add scale bar
d.barscale length=200 units=kilometers segment=4 fontsize=14

# Add North arrow
d.northarrow style=1b text_color=black

# Add text
d.text -b text="Month of maximum LST 2015-2017" \
color=black align=cc font=sans size=8


## Temporal aggregation (granularity of three months)

# 3-month mean LST
t.rast.aggregate input=LST_Day_monthly_celsius \
output=LST_Day_mean_3month \
basename=LST_Day_mean_3month suffix=gran \
method=average granularity="3 months"

# Check info
t.info input=LST_Day_mean_3month

# Check map list
t.rast.list input=LST_Day_mean_3month


## Display seasonal LST using frames

# Set STRDS color table to celsius degrees
t.rast.colors input=LST_Day_mean_3month color=celsius

# Start a new graphics monitor, the data will be rendered to
# /tmp/map.png image output file of size 640x360px
d.mon cairo out=frames.png width=640 height=360 resolution=4

# create a first frame
d.frame -c frame=first at=0,50,0,50
d.rast map=LST_Day_mean_3month_2015_07
d.vect map=nc_state type=boundary color=#4D4D4D width=2
  d.text text='Jul-Sep 2015' color=black font=sans size=10

# create a second frame
d.frame -c frame=second at=0,50,50,100
d.rast map=LST_Day_mean_3month_2015_10
d.vect map=nc_state type=boundary color=#4D4D4D width=2
  d.text text='Oct-Dec 2015' color=black font=sans size=10

# create a third frame
d.frame -c frame=third at=50,100,0,50
d.rast map=LST_Day_mean_3month_2015_01
d.vect map=nc_state type=boundary color=#4D4D4D width=2
  d.text text='Jan-Mar 2015' color=black font=sans size=10

# create a fourth frame
d.frame -c frame=fourth at=50,100,50,100
d.rast map=LST_Day_mean_3month_2015_04
d.vect map=nc_state type=boundary color=#4D4D4D width=2 
  d.text text='Apr-Jun 2015' color=black font=sans size=10

# release monitor
d.mon -r


## Time series animation

# Animation of monthly LST
g.gui.animation strds=LST_Day_mean_3month


## Extract zonal statistics for areas

# Install v.strds.stats add-on
g.extension extension=v.strds.stats

# Extract seasonal average LST for Raleigh urban area
v.strds.stats input=urbanarea strds=LST_Day_mean_3month \
where="NAME == 'Raleigh'" \
output=raleigh_aggr_lst method=average

# Save the attribute table of the new vector into a csv file
v.db.select map=raleigh_aggr_lst file=lst_raleigh

#~ cat|OBJECTID|UA|NAME|UA_TYPE|LST_Day_monthly_celsius_2015_01_01_average|LST_Day_monthly_celsius_2015_02_01_average|LST_Day_monthly_celsius_2015_03_01_average|LST_Day_monthly_celsius_2015_04_01_average|LST_Day_monthly_celsius_2015_05_01_average|LST_Day_monthly_celsius_2015_06_01_average|LST_Day_monthly_celsius_2015_07_01_average|LST_Day_monthly_celsius_2015_08_01_average|LST_Day_monthly_celsius_2015_09_01_average|LST_Day_monthly_celsius_2015_10_01_average|LST_Day_monthly_celsius_2015_11_01_average|LST_Day_monthly_celsius_2015_12_01_average|LST_Day_monthly_celsius_2016_01_01_average|LST_Day_monthly_celsius_2016_02_01_average|LST_Day_monthly_celsius_2016_03_01_average|LST_Day_monthly_celsius_2016_04_01_average|LST_Day_monthly_celsius_2016_05_01_average|LST_Day_monthly_celsius_2016_06_01_average|LST_Day_monthly_celsius_2016_07_01_average|LST_Day_monthly_celsius_2016_08_01_average|LST_Day_monthly_celsius_2016_09_01_average|LST_Day_monthly_celsius_2016_10_01_average|LST_Day_monthly_celsius_2016_11_01_average|LST_Day_monthly_celsius_2016_12_01_average|LST_Day_monthly_celsius_2017_01_01_average|LST_Day_monthly_celsius_2017_02_01_average|LST_Day_monthly_celsius_2017_03_01_average|LST_Day_monthly_celsius_2017_04_01_average|LST_Day_monthly_celsius_2017_05_01_average|LST_Day_monthly_celsius_2017_06_01_average|LST_Day_monthly_celsius_2017_07_01_average|LST_Day_monthly_celsius_2017_08_01_average|LST_Day_monthly_celsius_2017_09_01_average|LST_Day_monthly_celsius_2017_10_01_average|LST_Day_monthly_celsius_2017_11_01_average|LST_Day_monthly_celsius_2017_12_01_average
#~ 55|55|73261|Raleigh|UA|8.41692307692311|7.81769230769234|15.1792307692308|24.2661538461539|28.6676923076923|34.4|32.3146153846154|31.7415384615385|28.6076923076923|21.8938461538462|15.5084615384616|14.8515384615385|8.37615384615388|10.8084615384616|22.3984615384616|23.6061538461539|28.4638461538462|31.3746153846154|32.6684615384616|32.1061538461539|30.7476923076923|22.6569230769231|17.1615384615385|11.3415384615385|13.2807692307693|17.3823076923077|18.5507692307693|26.4038461538462|29.0292307692308|31.4423076923077|33.7869230769231|31.8584615384616|29.1169230769231|23.3869230769231|15.7769230769231|9.7792307692308

############################## THE END #################################

### Some extra examples if you are still interested ###

## Example of t.rast.accumulate and t.rast.accdetect application

# Accumulation
system('t.rast.accumulate input=LST_Day_monthly output=lst_acc limits=15,32 start="2015-03-01" cycle="7 months" offset="5 months" basename=lst_acc suffix=gran scale=0.02 shift=-273.15 method=mean granularity="1 month"')
# First cycle at 100°C - 190°C GDD
system('t.rast.accdetect input=lst_acc occ=insect_occ_c1 start="2015-03-01" cycle="7 months" range=100,200 basename=insect_c1 indicator=insect_ind_c1')
