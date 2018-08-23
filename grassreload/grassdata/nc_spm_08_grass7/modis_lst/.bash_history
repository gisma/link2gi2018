g.extension.all -f
r.modis.download -l
mkdir lst_monthly
ls gisdata/
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2015-01-01" endday="2016-12-31" folder=$HOME/lst_monthly
r.modis.import --h
cat /home/veroandreo/lst_monthly/listfileMOD11B3.006.txt
r.modis.import -w files=$HOME/lst_monthly/listfileMOD11B3.006.txt  spectral="( 1 1 1 1 )" outfile=$HOME/lst_monthly/monthly_lst_to_register.txt
g.list rast
g.remove rast pat=MOD11B3*
g.remove rast pat=MOD11B3* -f
r.modis.import -w files=$HOME/lst_monthly/listfileMOD11B3.006.txt  spectral="( 1 1 0 0 1 1 )" outfile=$HOME/lst_monthly/monthly_lst_to_register.txt
r.modis.import -w files=$HOME/lst_monthly/listfileMOD11B3.006.txt  spectral="( 1 1 0 0 1 1 )" outfile=$HOME/lst_monthly/monthly_lst_to_register.txt --o
cat /home/veroandreo/lst_monthly/monthly_lst_to_register.txt
d.mon wx0
d.rast MOD11B3.A2015060.h11v05.single_LST_Day_6km
g.list vect
d.vect nc_limites
r.colors MOD11B3.A2015060.h11v05.single_LST_Day_6km color=viridis
d.vect --h
d.mon wx0
d.rast MOD11B3.A2015060.h11v05.single_LST_Day_6km
d.vect nc_limites type=boundary
g.list vect
d.mon wx0
d.vect nc_state
r.colors MOD11B3.A2015060.h11v05.single_LST_Day_6km color=kelvin
d.mon wx0
d.rast MOD11B3.A2015060.h11v05.single_LST_Day_6km
t.rast.colors --h
r.colors --h
g.region raster=MOD11B3.A2015060.h11v05.single_LST_Day_6km
d.mon wx0
d.rast MOD11B3.A2015060.h11v05.single_LST_Day_6km
d.vect nc_state type=boundary
d.rast MOD11B3.A2015060.h11v05.single_LST_Day_6km
d.mon wx0
d.rast MOD11B3.A2015060.h11v05.single_LST_Day_6km

d.mon wx0
d.rast MOD11B3.A2015060.h11v05.single_LST_Day_6km
r.colors MOD11B3.A2015060.h11v05.single_LST_Day_6km color=viridis
d.vect nc_state type=boundary
g.region -p
r.modis.import -w files=$HOME/lst_monthly/listfileMOD11B3.006.txt  spectral="( 1 1 0 0 1 1 )" outfile=$HOME/lst_monthly/monthly_lst_to_register.txt --o
g.list rast
g.region -p raster=MOD11B3.A2015335.h11v05.single_LST_Day_6km
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2017-01-01" endday="2017-03-31" folder=$HOME/lst_monthly
vim /usr/lib/python2.7/site-packages/pymodis/downmodis.py
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2017-01-01" endday="2017-03-31" folder=$HOME/lst_monthly
g.extension r.modis
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2017-03-01" endday="2017-03-31" folder=$HOME/lst_monthly
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2017-04-01" endday="2017-04-31" folder=$HOME/lst_monthly
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2017-04-01" endday="2017-04-30" folder=$HOME/lst_monthly
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2017-04-01" endday="2017-05-01" folder=$HOME/lst_monthly
g.list vect
d.mon wx0
d.rast MOD11B3.A2015060.h11v05.single_LST_Day_6km
d.vect firestations
d.vect lakes
g.list vect
d.vect boundary_municp
d.vect geodetic_pts
d.mon wx0
d.vect comm_colleges
d.vect nc_state
d.vect comm_colleges
g.extension r.modis
r.modis.import -w files=$HOME/lst_monthly/listfileMOD11B3.006.txt  spectral="( 1 1 0 0 1 1 )" outfile=$HOME/lst_monthly/monthly_lst_to_register.txt --o
exit
g.extension.all -f
g.list rast
exit
g.extension --h
g.extension r.modis url=/home/veroandreo/software/grass_addons/grass7/raster/r.modis/
r.modis.import r.modis.import -w files=$HOME/lst_monthly/listfileMOD11B3.006.txt \
r.modis.import -w files=$HOME/lst_monthly/listfileMOD11B3.006.txt  spectral="( 1 1 0 0 1 1 )" outfile=$HOME/lst_monthly/monthly_lst_to_register.txt --o
exit
t.list
g.list rast
t.create type=strds temporaltype=absolute output=LST_Day_monthly  title="Monthly LST Day 5.6 km"  description="Monthly LST Day 5.6 km MOD11B3.006, 2015-2016"
t.info
t.info LST_Day_monthly
t.register -i input=LST_Day_monthly  maps=`g.list type=raster pattern=MOD11B3* separator=comma`  start="2015-01-01" increment="1 month"
t.info LST_Day_monthly
g.gui.timeline -3 inputs=LST_Day_monthly
t.register -i input=LST_Day_monthly  maps=`g.list type=raster pattern=MOD11B3*LST_Day* separator=comma`  start="2015-01-01" increment="1 months" --o
g.gui.timeline -3 inputs=LST_Day_monthly
t.remove LST_Day_monthly
g.list type=raster pattern=MOD11B3*LST_Day*
g.remove -f type=rast name=MOD11B3.A2017091.h11v05.single_LST_Day_6km
t.create type=strds temporaltype=absolute output=LST_Day_monthly  title="Monthly LST Day 5.6 km"  description="Monthly LST Day 5.6 km MOD11B3.006, 2015-2016"
t.register -i input=LST_Day_monthly  maps=`g.list type=raster pattern=MOD11B3*LST_Day* separator=comma`  start="2015-01-01" increment="1 months"
t.register -i input=LST_Day_monthly  maps=`g.list type=raster pattern=MOD11B3*LST_Day* separator=comma`  start="2015-01-01" increment="1 months" --o
t.rast.list LST_Day_monthly
g.gui.timeline -3 inputs=LST_Day_monthly
g.gui.timeline inputs=LST_Day_monthly
t.rast.algebra basename=LST_Day_monthly_celsius  expression="LST_Day_monthly_celsius = (LST_Day_monthly*0.02) - 273.15"
t.rast.color input=LST_Day_monthly color=celsius
t.rast.colors input=LST_Day_monthly_celsius color=celsius
exit
g.extension.all -f
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2017-05-01" endday="2017-06-01" folder=$HOME/lst_monthly
ls
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2017-05-01" endday="2017-06-01" folder=$HOME
r.modis.download --h
ls
exit
t.list
g.list rast
t.connect -d
t.create type=strds temporaltype=absolute output=LST_Day_monthly  title="Monthly LST Day 5.6 km"  description="Monthly LST Day 5.6 km MOD11B3.006, 2015-2016"
t.list type=strds
t.info input=LST_Day_monthly
t.register -i input=LST_Day_monthly  maps=`g.list type=raster pattern=MOD11B3*LST_Day* separator=comma`  start="2015-01-01" increment="1 months"
g.gui.timeline inputs=LST_Day_monthly
t.rast.list input=LST_Day_monthly order=min  columns=id,name,start_time,min where="min <= '14000'"
t.rast.list input=LST_Day_monthly order=min  columns=name,start_time,min where="min <= '14000'"
t.rast.list input=LST_Day_monthly order=max columns=name,start_time,max where="max > '14000'"
t.rast.list input=LST_Day_monthly columns=name,start_time  where="start_time >= '2015-03' and start_time <= '2016-01'"
t.rast.list input=LST_Day_monthly columns=name,start_time  where="strftime('%m', start_time)='01'"
t.rast.list input=LST_Day_monthly columns=name,start_time  where="strftime('%m-%d', start_time)='01-01'"
t.rast.list input=LST_Day_monthly columns=name,start_time  where="start_time >= '2015-03' and start_time <= '2015-08'"
t.rast.list input=LST_Day_monthly columns=name,start_time  where="start_time >= '2015-03' and start_time <= '2015-08-01 00:00:00'"
# maps from June, 1st
t.rast.list input=LST_Day_monthly columns=name,start_time  where="strftime('%m-%d', start_time)='06-01'"
t.rast.list input=LST_Day_monthly columns=name,start_time  where="start_time >= '2015-05' and start_time <= '2015-08-01 00:00:00'"
t.rast.univar input=LST_Day_monthly
t.rast.univar --h
t.rast.algebra basename=LST_Day_monthly_celsius  expression="LST_Day_monthly_celsius = (LST_Day_monthly*0.02) - 273.15"
exit
t.rast.algebra basename=LST_Day_monthly_celsius  expression="LST_Day_monthly_celsius = (LST_Day_monthly*0.02) - 273.15"
t.rast.algebra basename=LST_Day_monthly_celsius  expression="LST_Day_monthly_celsius = (LST_Day_monthly*0.02) - 273.15" --o
t.rast.list LST_Day_monthly_celsius
d.mon wx0
d.rast map=LST_Day_monthly_celsius_1
g.region -d
d.vect map=nc_state type=boundary
d.legend -t -s -d -b raster=LST_Day_monthly_celsius_1 title=LST title_fontsize=20 font=sans fontsize=18
d.barscale length=200 units=kilometers segment=4 fontsize=14
d.northarrow style=1b text_color=black
d.legend --h
d.legend -t -s -b raster=LST_Day_monthly_celsius_1 title=LST title_fontsize=20 font=sans fontsize=18
d.legend -t -s -b raster=LST_Day_monthly_celsius_1 title="LST (C)" title_fontsize=20 font=sans fontsize=18
d.text -b text="LST Day from MOD11B3.006 - North Carolina - March, 2015"  color=black bgcolor=229:229:229 align=cc font=sans size=8
d.rast map=LST_Day_monthly_celsius_4
t.rast.univar input=LST_Day_monthly -e
g.list vect
d.mon wx0
d.vect boundary_municp
d.mon wx0
d.vect boundary_wake
d.vect boundary_county
t.rast.series input=LST_Day_monthly_celsius output=LST_Day_max method=maximum
d.mon wx0
d.rast LST_Day_max
r.colors map=LST_Day_max color=celsius
d.mon wx0
d.rast LST_Day_max
d.legend LST_Day_max
t.rast.mapcalc -n inputs=LST_Day_monthly_celsius output=month_max_lst  expression="if(LST_Day_monthly_celsius == LST_Day_max, start_month(), null())"  basename=month_max_lst
t.info month_max_lst
t.rast.series input=month_max_lst method=maximum output=max_lst_date
d.mon wx0
d.rast max_lst_date
d.legend max_lst_date
t.rast.aggregate input=LST_Day_monthly_celsius output=LST_Day_mean_3month basename=LST_Day_mean_3month suffix=gran method=average granularity="3 months"
t.info LST_Day_mean_3month
g.list rast
 t.rast.list LST_Day_monthly
t.unregister --h
t.unregister input=LST_Day_monthly maps=MOD11B3.A2017091.h11v05.single_LST_Day_6km
t.rast.list LST_Day_monthly_celsius
t.unregister input=LST_Day_monthly_celsius maps=LST_Day_monthly_celsius_24
t.rast.series input=LST_Day_monthly_celsius output=LST_Day_max method=maximum
t.rast.series input=LST_Day_monthly_celsius output=LST_Day_max method=maximum -o
t.rast.series input=LST_Day_monthly_celsius output=LST_Day_max method=maximum --o
t.rast.mapcalc -n inputs=LST_Day_monthly_celsius output=month_max_lst  expression="if(LST_Day_monthly_celsius == LST_Day_max, start_month(), null())"  basename=month_max_lst --o
t.info month_max_lst
t.rast.series input=month_max_lst method=maximum output=max_lst_date --o
t.rast.aggregate input=LST_Day_monthly_celsius output=LST_Day_mean_3month basename=LST_Day_mean_3month suffix=gran method=average granularity="3 months" --o
t.rast.aggregate input=LST_Day_monthly_celsius output=LST_Day_mean_6month basename=LST_Day_mean_6month suffix=gran method=average granularity="6 months" --o
exit
r.colors map=max_lst_date@modis_lst color=differences
r.colors map=max_lst_date@modis_lst color=bcyr
r.colors map=max_lst_date@modis_lst color=viridis
t.list
t.rast.colors LST_Day_mean_3month color=celsius
t.rast.colors LST_Day_mean_6month color=celsius
t.rast.colors LST_Day_monthly_celsius@modis_lst color=celsius
d.mon wx0
d.rast map=max_lst_date
d.mon wx0
d.rast map=max_lst_date
d.vect map=nc_state type=boundary
d.legend -t -s -b raster=max_lst_date  title=LST title_fontsize=20 font=sans fontsize=18
d.legend -t -s -b raster=max_lst_date  title=Month title_fontsize=20 font=sans fontsize=18
d.barscale length=200 units=kilometers segment=4 fontsize=14
d.northarrow style=1b text_color=black
d.text -b text="Month of maximum LST 2015-2016"  color=black bgcolor=229:229:229 align=cc font=sans size=8
exit
r.out.mat input=LST_Day_max@modis_lst output=LST_Day_max
ls
gedit LST_Day_max.mat
exit
g.list vect
t.list
v.what.strds input=my_firestations strds=LST_Day_monthly_celsius@modis_lst output=sarara_delete
v.db.select sarara_delete
exit
/home/veroandreo/software/grass7_trunk/dist.x86_64-pc-linux-gnu/scripts/t.rast.list input=LST_Day_monthly@modis_lst
t.list 
t.rast.list
exit
cd Documents/
sh generate_GIF_animation.sh 
dnf provides gifsicle
su -
sh generate_GIF_animation.sh 
dnf provides convert
dnf provides ImageMagic
dnf provides ImageMagick
su -
sh generate_GIF_animation.sh 
gwenview animation_film.gif 
exit
/home/veroandreo/software/grass7_trunk/dist.x86_64-pc-linux-gnu/scripts/v.what.strds input=firestations@PERMANENT strds=LST_Day_mean_3month@modis_lst output=borrar
t.list
v.what.strds 
v.db.select borrar
exit
v.what.strds input=firestations@PERMANENT strds=LST_Day_mean_3month@modis_lst output=borrar2
v.db.select borrar2
g.list vect
g.remove -f vect name=borrar,borrar2,sarara_delete,my_firestations,puntos_escuelas
g.list vect
g.remove -f vect name=my_firestations,puntos_escuelas
exit
g.extension r.colors.matplotlib
g.list rast
r.colors.matplotlib map=max_lst_date color=RdYlBu
g.list rast

t.list
t.rast.colors LST_Day_mean_3month color=celsius
exit
g.list region
g.region region=blabla_curso
g.remove -f region=blabla_curso
g.remove -f region name=blabla_curso
g.list region
g.region region=wake_30m
g.list vect
g.region vect=zipcodes_wake
g.region --h
g.region vect=boundary_wake save=region_wake
g.region vect=nc_state save=region_nc
cd 
cd Documents/
sh generate_GIF_animation.sh 
gwenview animation_nc__film.gif
sh generate_GIF_animation.sh 
exit
cd Desktop/
display prueba.gif 
exit
g.gisenv -n
g.version -c
cd Desktop/
display prueba.gif 
g.version --h
g.version -e
g.version -be
g.version -bre
cd 
exit
g.list rast pat=LST_Day_m*
d.mon wx0
d.rast LST_Day_max
d.vect nc_state
d.mon wx0
d.rast LST_Day_max
d.vect map=nc_state type=boundary
d.legend -t -s -d -b raster=LST_Day_max  title=LST title_fontsize=20 font=sans fontsize=18
d.barscale length=200 units=kilometers segment=4 fontsize=14
d.northarrow style=1b text_color=black
d.text -b text="Maximum LST in the period 2015-2016 - North Carolina"  color=black bgcolor=229:229:229 align=cc font=sans size=8
d.mon wx0
d.rast LST_Day_max
d.legend -t -d -b raster=LST_Day_max  title=LST title_fontsize=20 font=sans fontsize=18
g.list vect
v.db.select geology
d.mon wx0
d.vect geology
exit
g.gui.animation --ui
g.gui.animation
exit
dnf provides python-pil
dnf provides python-pillow
t.list
g.gui.tplot strds=LST_Day_monthly_celsius@modis_lst coordinates=419604.018913,215736.80063
g.gui.animation strds=LST_Day_monthly_celsius@modis_lst
g.gui.mapswipe --h
g.list rast
g.gui.mapswipe --h
g.gui.mapswipe first=LST_Day_monthly_celsius_6 second=LST_Day_monthly_celsius_12
exit
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2017-05-01" endday="2017-06-01" folder=$HOME
exit
dnf provides pillow
dnf provides python-pillow
exit
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2017-05-01" endday="2017-06-01" folder=$HOME
g.extension r.modis
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2017-05-01" endday="2017-06-01" folder=$HOME
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600  tiles=h11v05 startday="2017-05-01" endday="2017-07-01" folder=$HOME
r.modis.download --help
r.modis.download -g settings=$HOME/gisdata/SETTING product=lst_terra_monthly_5600 tiles=h11v05 startday="2017-05-01" endday="2017-07-01" folder=$HOME
r.modis.download --help
r.modis.download -g settings=- product=lst_terra_monthly_5600 tiles=h11v05 startday="2017-05-01" endday="2017-07-01" folder=$HOME
r.modis.download -g settings=gisdata/SETTING product=lst_terra_monthly_5600 tiles=h11v05 startday="2017-05-01" endday="2017-07-01" folder=$HOME
exit
g.extension r.modis
r.modis.download -g settings=gisdata/SETTING product=lst_terra_monthly_5600 tiles=h11v05 startday="2017-05-01" endday="2017-07-01" folder=$HOME
exit
t.list
g.list rast
g.remove rast pat=*QC*
g.remove rast pat=*QC* -f
g.remove rast pat=*Night*
g.remove rast pat=*Night* -f
t.list
t.rast.list LST_Day_monthly@modis_lst
g.list rast pat=*A2017091*
g.remove rast name=MOD11B3.A2017091.h11v05.single_LST_Day_6km -f
exit
g.version -x
exit
/home/veroandreo/software/grass7_trunk/dist.x86_64-pc-linux-gnu/scripts/g.gui.tplot strds=LST_Day_monthly_celsius@modis_lst,LST_Day_monthly_celsius@modis_lst coordinates=419604.018913,215736.80063
t.list 
g.gui.tplot --ui
exit
r.mask -i vector=boundary_state@PERMANENT
r.mask -r
r.mask -r vector=boundary_state@PERMANENT
r.mask vector=boundary_state@PERMANENT
t.list
g.gui.tplot strds=LST_Day_monthly_celsius@modis_lst coordinates=419604.018913,215736.80063
g.gui
r.mask -r
exit
g.manual -i
g.manual -i
g.gui
+
g.manual --help
g.manual --h
exit
g.list type=vector pattern="r*"
g.list type=vector pattern="[ra]*"
g.list type=raster pattern="{soil,landuse}_*"
g.list rast
g.list type=raster pattern="{soil,landus}*"
g.list raster
d.mon wx0
d.rast soils
d.mon wx0
d.rast basins
d.rast landuse
g.region raster=elevation
g.region -p
d.rast basins
g.region n=n-2000 w=w-5000
r.mapcalc "new_elev = elevation"
d.rast new_elev
g.region raster=elevation
g.region n=n-3000 w=w+4000 
r.mapcalc "new_elev = elevation" --o
d.mon wx0
d.rast new_elev
d.rast elevation
d.rast new_elev
r.colors new_elev color=viridis
d.rast new_elev
exit
/home/veroandreo/grassdata/nc_basic_spm_grass7/modis_lst/.tmp/ipv6.dynamic.ziggo.nl/3223.0.py
/home/veroandreo/grassdata/nc_basic_spm_grass7/modis_lst/.tmp/ipv6.dynamic.ziggo.nl/3223.0.py
/home/veroandreo/test.py
/home/veroandreo/test.py
g.mapset -p
g.gui
t.list
t.remove LST_Day_monthly
t.list
t.info LST_Day_monthly@modis_lst
t.remove LST_Day_monthly
t.list 
t.info LST_Day_monthly@modis_lst
t.list 
t.remove -rf inputs=LST_Day_mean_3month@modis_lst,LST_Day_mean_6month@modis_lst,month_max_lst@modis_lst,LST_Day_monthly_celsius@modis_lst
t.list
t.remove LST_Day_monthly@modis_lst
g.list rast mapset=.
g.remove rast name=max_lst_date,month_max_lst_25,new_elev
g.remove rast name=max_lst_date,month_max_lst_25,new_elev -f
g.list rast mapset=.
g.remove -f rast name=LST_Day_max,LST_Day_mean_3month_2017_01,LST_Day_monthly_celsius_24
g.list rast mapset=.
g.list vect mapset=.
g.list region mapset=.
g.remove region name=region_nc,region_wake -f
g.list region mapset=.
exit
g.mapset -p
t.list
g.list rast
exit
g.list
g.list rast
d.mon wx0
d.rast MOD11B3.A2016183.h11v05.single_LST_Day_6km
exit
r.colors map=MOD11B3.A2015001.h11v05.single_LST_Day_6km@modis_lst color=viridis
r.colors map=MOD11B3.A2015121.h11v05.single_LST_Day_6km@modis_lst color=blues
d.mon wx0
d.rast MOD11B3.A2016183.h11v05.single_LST_Day_6km
g.region -p
g.region -p raster=MOD11B3.A2016183.h11v05.single_LST_Day_6km
r.out.gdal in=MOD11B3.A2016183.h11v05.single_LST_Day_6km out=MOD11B3.A2016183.h11v05.single_LST_Day_6km.tif
qgis MOD11B3.A2016183.h11v05.single_LST_Day_6km.tif &
r.out.gdal in=elevation out=elevation.tif
g.gui
r.color --h
r.colors --h
r.info --h
r.info MOD11B3.A2015244.h11v05.single_LST_Day_6km
r.info MOD11B3.A2015244.h11v05.single_LST_Day_6km -h
r.colors --h
r.colors MOD11B3.A2015244.h11v05.single_LST_Day_6km@modis_lst
g.list rast
g.list rast mapset=.
for map in `g.list rast mapset=.` ; do r.colors map=${map} color=grey ; done
d.mon wx0 
d.rast MOD11B3.A2016061.h11v05.single_LST_Day_6km
t.list
g.list vect
g.list vect mapset=.
exit
t.list
exit
g.region -p vector=nc_state align=MOD11B3.A2015060.h11v05.single_LST_Day_6km
d.mon wx0
d.rast MOD11B3.A2015060.h11v05.single_LST_Day_6km
r.mask vector=nc_state
r.colors MOD11B3.A2015060.h11v05.single_LST_Day_6km color=viridis
d.rast MOD11B3.A2015090.h11v05.single_LST_Day_6km
g.list rast
d.rast MOD11B3.A2015091.h11v05.single_LST_Day_6km
r.colors MOD11B3.A2015091.h11v05.single_LST_Day_6km color=viridis
g.list rast
d.rast MOD11B3.A2015121.h11v05.single_LST_Day_6km
r.colors MOD11B3.A2015121.h11v05.single_LST_Day_6km color=viridis
g.list rast
d.rast MOD11B3.A2015152.h11v05.single_LST_Day_6km
r.colors MOD11B3.A2015152.h11v05.single_LST_Day_6km color=viridis
r.series --h
r.series input=MOD11B3.A2015060.h11v05.single_LST_Day_6km,MOD11B3.A2015091.h11v05.single_LST_Day_6km,MOD11B3.A2015121.h11v05.single_LST_Day_6km,MOD11B3.A2015152.h11v05.single_LST_Day_6km output=lst_average method=average
d.mon wx0
d.rast lst_average
t.create type=strds temporaltype=absolute output=LST_Day_monthly   title="Monthly LST Day 5.6 km"   description="Monthly LST Day 5.6 km MOD11B3.006, 2015-2016"
t.register -i input=LST_Day_monthly  maps=`g.list type=raster pattern=MOD11B3*LST_Day* separator=comma`  start="2015-01-01" increment="1 months"
t.list
t.rast.list LST_Day_monthly@modis_lst
t.rast.accumulate --h
t.rast.accumulate input=LST_Day_monthly output=lst_acc lower=15 upper=32 start="2015-03-01" stop="2016-12-31" cycle="7 months" offset="5 months" basename=lst_acc suffix=gran scale=0.02 shift=-273.15 method=mean
t.rast.accumulate input=LST_Day_monthly output=lst_acc limits=15,32 start="2015-03-01" stop="2016-12-31" cycle="7 months" offset="5 months" basename=lst_acc suffix=gran scale=0.02 shift=-273.15 method=mean
t.rast.accumulate input=LST_Day_monthly output=lst_acc limits=15,32 start="2015-03-01" stop="2016-12-31" cycle="7 months" offset="5 months" basename=lst_acc suffix=gran scale=0.02 shift=-273.15 method=mean --o
t.list 
t.rast.list lst_acc
t.rast.accumulate --h
t.rast.accumulate input=LST_Day_monthly output=lst_acc limits=15,32 start="2015-03-01" cycle="7 months" offset="5 months" basename=lst_acc suffix=gran scale=0.02 shift=-273.15 method=mean granularity="1 month" --o
t.list 
t.rast.list lst_acc
t.rast.colors --h
t.rast.colors input=lst_acc color=viridis
d.mon wx0
d.rast lst_acc_2015_03
d.rast lst_acc_2015_04
d.rast lst_acc_2015_05
d.rast lst_acc_2015_06
d.rast lst_acc_2015_07
d.rast lst_acc_2015_08
d.rast lst_acc_2015_09
d.rast lst_acc_2015_06
d.rast lst_acc_2015_07
d.rast lst_acc_2015_08
d.rast lst_acc_2015_09
t.rast.accumulate --h
t.rast.accdetect --h
man t.rast.accdetect
man t.rast.accumulate
t.rast.list lst_acc columns=name,min,max
# First cycle at 100°C - 190°C GDD
t.rast.accdetect input=lst_acc       occ=insect_occ_c1 start="2015-03-01"       cycle="7 months" range=100,200 basename=insect_c1 indicator=insect_ind_c1
t.list
t.rast.list insect_ind_c1 columns=name,min,max
d.mon wx0
d.rast insect_c1_indicator_2015_08
t.rast.list insect_occ_c1 columns=name,min,max
exit
g.manual entry=wxGUI.mapswipe
g.extension i.modis
i.modis.import --h
i.modis.import -l
g.list rast
i.modis.import files=Desktop/mod11/listfileMOD11B3.006.txt spectral="( 1 0 0 0 0 0 0 0 0 0 0 0 )"
g.list rast
r.info MOD11B3.A2017091.h11v05.single_LST_Day_6km
g.list rast mapset=.
g.region -p vector=nc_state   align=MOD11B3.A2015060.h11v05.single_LST_Day_6km
d.mon wx0
d.rast map=MOD11B3.A2015060.h11v05.single_LST_Day_6km
d.vect --h
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.legend -t -s -b raster=MOD11B3.A2015060.h11v05.single_LST_Day_6km   title=LST title_fontsize=20 font=sans fontsize=18
d.legend --h
d.legend -t -s -b raster=MOD11B3.A2015060.h11v05.single_LST_Day_6km   title=LST title_fontsize=20 font=sans fontsize=18   at=0,0
d.legend -t -s -b raster=MOD11B3.A2015060.h11v05.single_LST_Day_6km   title=LST title_fontsize=20 font=sans fontsize=18   at=10,10
d.legend -t -s -b raster=MOD11B3.A2015060.h11v05.single_LST_Day_6km   title=LST title_fontsize=20 font=sans fontsize=18   at=10,10,10,10
d.barscale length=200 units=kilometers segment=4 fontsize=14
d.northarrow style=1b text_color=black
d.barscale --h
d.barscale -n length=200 units=kilometers segment=4 fontsize=14
d.text -b text="LST Day from MOD11B3.006 - North Carolina - March, 2015"   color=black bgcolor=229:229:229 align=cc font=sans size=8
d.mon wx0
d.rast map=MOD11B3.A2015060.h11v05.single_LST_Day_6km
d.text -b text="LST Day from MOD11B3.006 - North Carolina - March, 2015"   color=black bgcolor=229:229:229 align=cc font=sans size=8
d.mon wx0
d.rast map=MOD11B3.A2015060.h11v05.single_LST_Day_6km
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.legend -t -s -b raster=MOD11B3.A2015060.h11v05.single_LST_Day_6km   title=LST title_fontsize=20 font=sans fontsize=16
d.legend -t -s raster=MOD11B3.A2015060.h11v05.single_LST_Day_6km   title="MODIS LST" title_fontsize=18 font=sans fontsize=16
# Add scale bar
d.barscale length=200 units=kilometers segment=4 fontsize=14   text_position=under
d.northarrow style=1b text_color=black
t.list
t.create type=strds temporaltype=absolute output=LST_Day_monthly   title="Monthly LST Day 5.6 km"   description="Monthly LST Day 5.6 km MOD11B3.006, 2015-2017" --o
t.info LST_Day_monthly
t.register -i input=LST_Day_monthly  maps=`g.list type=raster pattern=MOD11B3*LST_Day* separator=comma`  start="2015-01-01" increment="1 months"
t.register -i input=LST_Day_monthly  maps=`g.list type=raster pattern=MOD11B3*LST_Day* separator=comma`  start="2015-01-01" increment="1 months" --o
t.info LST_Day_monthly
strace 
strace -h
strace t.list 
strace t.list > out_tlist
cat out_tlist 
strace t.info LST_Day_monthly
t.register -i input=LST_Day_monthly  maps=`g.list type=raster pattern=MOD11B3*LST_Day* separator=comma`  start="2015-01-01" increment="1 months" --o
strace t.info LST_Day_monthly
g.version --h
g.version -b
g.version -r
t.rast.list input=LST_Day_monthly
t.rast.list input=LST_Day_monthly columns=name,min,max
t.rast.algebra --h
t.rast.algebra basename=LST_Day_monthly_celsius suffix=gran   expression="LST_Day_monthly_celsius = LST_Day_monthly * 0.02 - 273.15"
t.rast.list LST_Day_monthly_celsius
t.rast.list LST_Day_monthly_celsius columns=name,min,max
t.rast.list input=LST_Day_monthly_celsius order=min  columns=name,start_time,min where="min <= '5.0'"
t.rast.list --h
# Maps with maximum value higher than 30
t.rast.list input=LST_Day_monthly_celsius order=max  columns=name,start_time,max where="max > '30.0'"
# Maps between two given dates
t.rast.list input=LST_Day_monthly_celsius columns=name,start_time  where="start_time >= '2015-05' and start_time <= '2015-08-01 00:00:00'"
# Maps from January
t.rast.list input=LST_Day_monthly_celsius columns=name,start_time  where="strftime('%m', start_time)='01'"
# Maps from June, 1st
t.rast.list input=LST_Day_monthly_celsius columns=name,start_time  where="strftime('%m-%d', start_time)='06-01'"
t.rast.aggregate input=LST_Day_monthly_celsius   output=LST_Day_mean_3month   basename=LST_Day_mean_3month suffix=gran   method=average granularity="3 months" --o
g.gui
g.list vect
g.gui.timeline 
g.gui.timeline input=LST_Day_monthly_celsius,LST_Day_mean_3month
t.rast.univar input=LST_Day_monthly_celsius
t.rast.univar -e input=LST_Day_monthly_celsius
t.rast.series input=LST_Day_monthly_celsius   output=LST_Day_max method=maximum --o
# Change color pallete to celsius
r.colors map=LST_Day_max color=celsius
d.mon wx0
d.rast LST_Day_max
d.mon wx0
d.rast LST_Day_max
t.rast.series input=LST_Day_monthly_celsius   output=LST_Day_min method=minimum --o
r.colors map=LST_Day_min,LST_Day_max color=celsius
exit
i.modis.import --h
i.modis.import -l
exit
t.list 
t.list --h
t.rast.list LST_Day_monthly
t.info LST_Day_monthly
exit
v.colors map=raleigh_aggr_lst@modis_lst use=attr column=LST_Day_monthly_celsius_2015_01_01_average color=celsius
# Maps with minimum value lower than or equal to 5
t.rast.list input=LST_Day_monthly_celsius order=min  columns=name,start_time,min where="min <= '5.0'"
t.rast.list input=LST_Day_monthly_celsius order=max  columns=name,start_time,max where="max > '30.0'"
t.rast.list input=LST_Day_monthly_celsius columns=name,start_time  where="start_time >= '2015-05' and start_time <= '2015-08-01 00:00:00'"
t.rast.list input=LST_Day_monthly_celsius columns=name,start_time  where="strftime('%m', start_time)='01'"
# Print univariate stats for maps within STRDS
t.rast.univar input=LST_Day_monthly_celsius
g.list rast
g.gui.mapswipe first=LST_Day_max second=elev_state_500m
g.mapset -p
g.gui.mapswipe first=LST_Day_max second=elev_state_500m
d.mon cairo out=/tmp/map.png width=600 height=540 --o
d.frame -e
d.frame -c frame=first at=0,50,0,50
d.rast LST_Day_max
d.frame -c frame=second at=0,50,50,100
d.rast LST_Day_min
d.mon -r
gwenview /tmp/map.png &
g.gui.tplot strds=LST_Day_monthly_celsius   coordinates=641428.783478,229901.400746
g.gui.tplot 
g.gui.tplot strds=LST_Day_monthly_celsius coordinates=641428.783478,229901.400746
g.gui.tplot
g.gui.tplot --h
g.gui.tplot strds=LST_Day_monthly_celsius coordinates=641428.783478,229901.400746 output=test.png
g.gui.tplot strds=LST_Day_monthly_celsius coordinates=641428.783478,229901.400746 csv=test.csv
g.gui.tplot strds=LST_Day_monthly_celsius coordinates=641428.783478,229901.400746
g.gui.tplot strds=LST_Day_monthly_celsius coordinates=641428.783478,229901.400746 csv=bla
g.gui.tplot --h
g.gui.tplot strds=LST_Day_monthly_celsius   coordinates=641428.783478,229901.400746   tittle="Monthly LST. City center of Raleigh, NC "   xlabel="Time" ylabel="LST"   csv=raleigh_monthly_LST.csv
g.gui.tplot strds=LST_Day_monthly_celsius   coordinates=641428.783478,229901.400746   title="Monthly LST. City center of Raleigh, NC "   xlabel="Time" ylabel="LST"   csv=raleigh_monthly_LST.csv
g.gui.animation strds=LST_Day_monthly_celsius
t.rast.colors input=LST_Day_monthly_celsius color=celsius
g.gui.animation strds=LST_Day_monthly_celsius
g.extension extension=v.strds.stats
v.strds.stats input=urbanarea strds=LST_Day_monthly_celsius   where="NAME == 'Raleigh'"   output=raleigh_aggr_lst method=average
v.db.select map=raleigh_aggr_lst
t.rast.list input=LST_Day_mean_3month
d.mon cairo out=/tmp/map.png width=600 height=480 --o
d.frame -c frame=first at=0,50,0,50
d.rast map=LST_Day_mean_3month_2015_01
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jan-Mar 2015' bgcolor=220:220:220 color=black size=6
# create a second frame
d.frame -c frame=second at=0,50,50,100
d.rast map=LST_Day_mean_3month_2015_04
d.vect map=nc_state type=boundary color=#4D4D4D width=2 
d.text text='Apr-Jun 2015' bgcolor=220:220:220 color=black size=6
# create a third frame
d.frame -c frame=third at=50,100,0,50
d.rast map=LST_Day_mean_3month_2015_07
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jul-Sep 2015' bgcolor=220:220:220 color=black size=6
# create a fourth frame
d.frame -c frame=fourth at=50,100,50,100
d.rast map=LST_Day_mean_3month_2015_10
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Oct-Dec 2015' bgcolor=220:220:220 color=black size=6
gwenview /tmp/map.png 
d.mon --h
d.mon cairo out=/tmp/map.png width=640 height=400 resolution=3 --o
d.mon -r
d.mon cairo out=/tmp/map.png width=640 height=400 resolution=3 --o
# create a first frame
d.frame -c frame=first at=0,50,0,50
d.rast map=LST_Day_mean_3month_2015_01
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jan-Mar 2015' bgcolor=220:220:220 color=black size=6
# create a second frame
d.frame -c frame=second at=0,50,50,100
d.rast map=LST_Day_mean_3month_2015_04
d.vect map=nc_state type=boundary color=#4D4D4D width=2 
d.text text='Apr-Jun 2015' bgcolor=220:220:220 color=black size=6
# create a third frame
d.frame -c frame=third at=50,100,0,50
d.rast map=LST_Day_mean_3month_2015_07
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jul-Sep 2015' bgcolor=220:220:220 color=black size=6
# create a fourth frame
d.frame -c frame=fourth at=50,100,50,100
d.rast map=LST_Day_mean_3month_2015_10
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Oct-Dec 2015' bgcolor=220:220:220 color=black size=6
gwenview /tmp/map.png 
gwenview /tmp/map.png &
d.text --h
d.mon -r
d.mon cairo out=/tmp/map.png width=640 height=360 resolution=4 --o
# create a first frame
d.frame -c frame=first at=0,50,0,50
d.rast map=LST_Day_mean_3month_2015_01
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jan-Mar 2015' color=black font=sans size=10
# create a second frame
d.frame -c frame=second at=0,50,50,100
d.rast map=LST_Day_mean_3month_2015_04
d.vect map=nc_state type=boundary color=#4D4D4D width=2 
d.text text='Apr-Jun 2015' color=black font=sans size=10
# create a third frame
d.frame -c frame=third at=50,100,0,50
d.rast map=LST_Day_mean_3month_2015_07
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jul-Sep 2015' color=black font=sans size=10
# create a fourth frame
d.frame -c frame=fourth at=50,100,50,100
d.rast map=LST_Day_mean_3month_2015_10
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Oct-Dec 2015' color=black font=sans size=10
# release monitor
d.mon -r
gwenview /tmp/map.png &
exit
t.rast.colors input=LST_Day_mean_3month color=celsius
d.mon cairo out=frames.png width=640 height=360 resolution=4 --o
# create a third frame
d.frame -c frame=third at=50,100,0,50
d.rast map=LST_Day_mean_3month_2015_07
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jul-Sep 2015' color=black font=sans size=10
# create a fourth frame
d.frame -c frame=fourth at=50,100,50,100
d.rast map=LST_Day_mean_3month_2015_10
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Oct-Dec 2015' color=black font=sans size=10
# create a first frame
d.frame -c frame=first at=0,50,0,50
d.rast map=LST_Day_mean_3month_2015_01
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jan-Mar 2015' color=black font=sans size=10
# create a second frame
d.frame -c frame=second at=0,50,50,100
d.rast map=LST_Day_mean_3month_2015_04
d.vect map=nc_state type=boundary color=#4D4D4D width=2 
d.text text='Apr-Jun 2015' color=black font=sans size=10
# release monitor
d.mon -r
d.mon cairo out=frames.png width=640 height=360 resolution=4 --o
# create a first frame
d.frame -c frame=first at=0,50,0,50
d.rast map=LST_Day_mean_3month_2015_01
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jan-Mar 2015' color=black font=sans size=10
# create a second frame
d.frame -c frame=second at=0,50,50,100
d.rast map=LST_Day_mean_3month_2015_04
d.vect map=nc_state type=boundary color=#4D4D4D width=2 
d.text text='Apr-Jun 2015' color=black font=sans size=10
# create a third frame
d.frame -c frame=third at=50,100,0,50
d.rast map=LST_Day_mean_3month_2015_07
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jul-Sep 2015' color=black font=sans size=10
# create a fourth frame
d.frame -c frame=fourth at=50,100,50,100
d.rast map=LST_Day_mean_3month_2015_10
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Oct-Dec 2015' color=black font=sans size=10
# release monitor
d.mon -r
d.mon cairo out=frames.png width=640 height=360 resolution=4 --o
# create a third frame
d.frame -c frame=third at=50,100,0,50
d.rast map=LST_Day_mean_3month_2015_07
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jul-Sep 2015' color=black font=sans size=10
# create a fourth frame
d.frame -c frame=fourth at=50,100,50,100
d.rast map=LST_Day_mean_3month_2015_10
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Oct-Dec 2015' color=black font=sans size=10
# create a first frame
d.frame -c frame=first at=0,50,0,50
d.rast map=LST_Day_mean_3month_2015_01
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jan-Mar 2015' color=black font=sans size=10
# create a second frame
d.frame -c frame=second at=0,50,50,100
d.rast map=LST_Day_mean_3month_2015_04
d.vect map=nc_state type=boundary color=#4D4D4D width=2 
d.text text='Apr-Jun 2015' color=black font=sans size=10
# release monitor
d.mon -r
d.mon cairo out=frames.png width=640 height=360 resolution=4 --o
# create a first frame
d.frame -c frame=first at=0,50,0,50
d.rast map=LST_Day_mean_3month_2015_01
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jul-Sep 2015' color=black font=sans size=10
# create a second frame
d.frame -c frame=second at=0,50,50,100
d.rast map=LST_Day_mean_3month_2015_04
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Oct-Dec 2015' color=black font=sans size=10
# create a third frame
d.frame -c frame=third at=50,100,0,50
d.rast map=LST_Day_mean_3month_2015_07
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.text text='Jan-Mar 2015' color=black font=sans size=10
# create a fourth frame
d.frame -c frame=fourth at=50,100,50,100
d.rast map=LST_Day_mean_3month_2015_10
d.vect map=nc_state type=boundary color=#4D4D4D width=2 
d.text text='Apr-Jun 2015' color=black font=sans size=10
# release monitor
d.mon -r
d.mon cairo out=frames.png width=640 height=360 resolution=4 --o
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
exit
t.rast.list input=LST_Day_mean_3month
v.db.select map=raleigh_aggr_lst file=lst_raleigh
g.list vect
v.db.select map=raleigh_aggr_lst
g.list rast
t.rast.mapcalc -n inputs=LST_Day_monthly_celsius output=month_max_lst   expression="if(LST_Day_monthly_celsius == LST_Day_max, start_month(), null())"   basename=month_max_lst --o
# Get basic info
t.info month_max_lst
t.rast.series input=month_max_lst method=minimum output=max_lst_date --o
t.remove -rf inputs=month_max_lst
d.mon wx0
d.rast map=max_lst_date
d.vect map=nc_state type=boundary color=#4D4D4D width=2
d.legend -t -s raster=max_lst_date title="Month"   title_fontsize=20 font=sans fontsize=18
d.barscale length=200 units=kilometers segment=4 fontsize=14
d.northarrow style=1b text_color=black
d.text -b text="Month of maximum LST 2015-2017"   color=black align=cc font=sans size=8
g.gui.animation 
exit
t.list
t.remove -rf lst_acc@modis_lst
t.remove --h
t.remove -rf inputs=insect_ind_c1@modis_lst,insect_occ_c1@modis_lst
t.remove -rf inputs=LST_Day_mean_3month@modis_lst,LST_Day_monthly_celsius@modis_lst
t.remove inputs=LST_Day_monthly@modis_lst
g.list rast
g.list rast mapset=.
g.remove -f rast name=LST_Day_max,LST_Day_min,lst_average,max_lst_date
r.mask -r
g.list rast mapset=.
g.list vect mapset=.
g.remove vect name=raleigh_aggr_lst -f
g.list vect mapset=.
exit
