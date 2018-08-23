test -r ~/.alias && . ~/.alias
PS1='GRASS 7.5.svn (nc_spm_08_grass7):\w > '
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
export PATH="/home/veroandreo/software/grass7_trunk/dist.x86_64-pc-linux-gnu/bin:/home/veroandreo/software/grass7_trunk/dist.x86_64-pc-linux-gnu/scripts:/home/veroandreo/.grass7/addons/bin:/home/veroandreo/.grass7/addons/scripts:/home/veroandreo/software/grass74_release/bin.x86_64-pc-linux-gnusoftware/:/usr/libexec/python2-sphinx:/home/veroandreo/software/grass74_release/bin.x86_64-pc-linux-gnusoftware:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/home/veroandreo/.local/bin:/home/veroandreo/bin"
export HOME="/home/veroandreo"
