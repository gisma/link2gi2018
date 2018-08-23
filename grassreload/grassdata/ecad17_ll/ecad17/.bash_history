cd ~/data/ecad/ecad_v17/annual/grass_pack/
for i in `ls *.pack` ; do r.unpack $i ; done
cd ../../monthly/grass_pack/
for i in `ls *.pack` ; do r.unpack $i ; done
cd ../..
ls
for i in `ls *.pack` ; do r.unpack $i ; done
g.list raster
g.region raster=precip.1951_1980.01.sum -p
g.proj -w
