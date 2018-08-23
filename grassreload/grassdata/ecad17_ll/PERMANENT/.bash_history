v.import input="/vsizip/vsicurl/https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_admin_1_states_provinces.zip" output=ne_10m_admin_1_states_provinces
exit
g.region vector=ne_10m_admin_1_states_provinces res=0:01 -p -a
