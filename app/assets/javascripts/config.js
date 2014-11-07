
var config = {
	map: {
		prj:'codeforamerica.hmebo8ll', // Mapbox map id string
		center_location: [33.4019, -111.78],
		marker_location: [33.42, -111.835],
		start_zoom: 12,
		district_fill: 'white',
		districtsQueryESRIurl: 'https://services2.arcgis.com/1gVyYKfYgW5Nxb1V/ArcGIS/rest/services/MesaCouncilDistricts/FeatureServer/0/query?where=DISTRICT+IS+NOT+NULL&outSR=4326&f=json',
	},
	disqus: {
		shortname: 'yerhere', // required: replace example with your forum shortname
		base_url: 'http://municipal.codeforamerica.org'
	}
}