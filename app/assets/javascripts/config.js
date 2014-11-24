
var config = {
	map: {
		prj:'codeforamerica.hmebo8ll', // Mapbox map id string
		center_location: [33.4019, -111.78], //lat, lng
		marker_location: [33.42, -111.835], //lat, lng
		start_zoom: 12,
		district_fill: 'white',
		districtsQueryESRIurl: 'https://services2.arcgis.com/1gVyYKfYgW5Nxb1V/ArcGIS/rest/services/MesaCouncilDistricts/FeatureServer/0/query?where=DISTRICT+IS+NOT+NULL&outSR=4326&f=json',
	},
	disqus: {
		shortname: 'mesamunicipal', // required: replace example with your forum shortname
		base_url: 'http://mesaazmunicipal.herokuapp.com'
	}
}
