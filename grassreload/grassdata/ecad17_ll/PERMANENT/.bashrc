test -r ~/.alias && . ~/.alias
PS1='GRASS 7.5.svn (ecad17_ll):\w > '
grass_prompt() {
	LOCATION="`g.gisenv get=GISDBASE,LOCATION_NAME,MAPSET separator='/'`"
	if test -d "$LOCATION/grid3/G3D_MASK" && test -f "$LOCATION/cell/MASK" ; then
		echo [2D and 3D raster MASKs present]
	elif test -f "$LOCATION/cell/MASK" ; then
		echo [Raster MASK present]
	elif test -d "$LOCATION/grid3/G3D_MASK" ; then
		echo [3D raster MASK present]
	fi
}
PROMPT_COMMAND=grass_prompt
export PATH="/home/mneteler/software/grass75/dist.x86_64-pc-linux-gnu/bin:/home/mneteler/software/grass75/dist.x86_64-pc-linux-gnu/scripts:/home/mneteler/.grass7/addons/bin:/home/mneteler/.grass7/addons/scripts:/usr/libexec/python2-sphinx:/usr/lib64/qt-3.3/bin:/usr/share/Modules/bin:/usr/lib64/ccache:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/var/lib/snapd/snap/bin:/home/mneteler/bin"
export HOME="/home/mneteler"
