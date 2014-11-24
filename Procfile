web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker: ogr2ogr -f "GeoJSON" app/assets/javascripts/bounds.json "https://services2.arcgis.com/1gVyYKfYgW5Nxb1V/ArcGIS/rest/services/MesaCouncilDistricts/FeatureServer/0/query?where=objectid+%3D+objectid&objectIds=&outSR=4326&f=json
" OGRGeoJSON -t_srs "EPSG:4326"