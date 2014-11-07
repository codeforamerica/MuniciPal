// GLOBAL VARIABLES FOR DEBUGGING
// g_data contains district information and city council items
// g_districts contains district information
var g_data, g_districts;

/*
==========================================
==========================================
==========================================
========START MAP & GEO SECTION===========
==========================================
==========================================
==========================================
*/

var map, marker, districtLayer, otherDistrictsLayer;

function mapInitialize() {

  map = L.mapbox.map(
    'map',
    config.map.prj,
    {
      center: config.map.center_location,
      zoom: config.map.start_zoom,
      minZoom: 6,
      maxZoom: 18,
      scrollWheelZoom: false,
    }
  );

  districtLayer = L.mapbox.featureLayer(null, {}).addTo(map);

  marker = L.marker(config.map.marker_location, {
        icon: L.mapbox.marker.icon({'marker-color': 'CC0033'}),
        draggable: true
        });
  marker.addTo(map);
  marker.bindPopup("<b>Click and drag me!</b>").openPopup();
  marker.on('dragend', onDragEnd);

  fetchDistricts();
}



/*
==========================================
===HELPER FUNCTIONS FOR MAP AND GEO=======
==========================================
*/

function onDragEnd() {
    var ll = marker.getLatLng();
    updatePage({'lat': ll.lat, 'lng': ll.lng});
}

/* Expects an object of type tomsline which is what the tom-geocoder service returns.
   Puts it on the map.
   */
function linesToMap(tomsline) {
  /* tomsline should look like:
  {
    text: [
      ["w streetname ave", { geojson }],
      ["w otherroad rd", { geojson }],
      ...
    ]
  }
  */
  var districtLines = L.geoJson().addTo(map);

  lines = tomsline.text;
  _.forEach(lines, function(line) {
    // map them
    console.log("mapping: " + line[0]);
    districtLines.addData($.parseJSON(line[1]));
  });

}

/* For any given text, run it through the geocoder so we can put it on a map. */
/* idea: later, clicking on that thing could pull up the item below. */
function textToGeo(text) {
   $.ajax({
    type: 'POST',
    crossDomain: true,
    url: 'http://findlines-staging.herokuapp.com/',
    data: { fileupload: text},
    dataType: 'json',
    success: linesToMap,
  });
}

// see http://leafletjs.com/examples/choropleth.html
function highlightFeature(e) {
  var layer = e.target;

  layer.setStyle({
      weight: 3,
      color: '#2262CC',
      dashArray: '',
      opacity: 0.6,
      fillOpacity: 0.4,
  });

  if (!L.Browser.ie && !L.Browser.opera) {
      layer.bringToFront();
  }
}


function resetHighlight(e) {
  otherDistrictsLayer.resetStyle(e.target);
}


function jumpToFeature(e) {
  updatePage({'lat': e.latlng.lat, 'lng': e.latlng.lng});
  console.log("jumping to district ");
}

var convertESRItoGeoJSON = function (esriJSON) {
  var geoJSON = { type: "FeatureCollection", features: [] };
  _.each(esriJSON.features, function(feature) {
    geoJSON.features.push(Terraformer.ArcGIS.parse(feature /* {sr: 4326 } */))
  });
  return geoJSON;
}

// fetch districts, then add them to map
function fetchDistricts() {
   $.ajax({
    type: 'POST',
    crossDomain: true,
    url: config.map.districtsQueryESRIurl,
    dataType: 'json',
    success: addDistrictsToMap,
  });
}

function addDistrictsToMap(districts) {

  // if it looks like districts is in ESRI JSON, convert it first
  var geoJSONdistricts;
  if (typeof districts.geometryType != "undefined" &&
      districts.geometryType === "esriGeometryPolygon") {
    geoJSONdistricts = convertESRItoGeoJSON(districts);
  } else {
    geoJSONdistricts = districts;
  }

  otherDistrictsLayer = L.geoJson(geoJSONdistricts, {
    style: function (feature) {
      return {
          fillColor: config.map.district_fill,
          weight: 1,
          opacity: 0.7,
          fillOpacity: 0.2,
          color: 'black',
          dashArray: '3',
      };
    },
    onEachFeature: function (feature, layer) {
      layer.on({
          mouseover: highlightFeature,
          mouseout: resetHighlight,
          click: jumpToFeature
      });
    }
  }).addTo(map);

  // How to add static label at center of polygon (from web example)
  // label = new L.Label()
  // label.setContent("static label")
  // label.setLatLng(polygon.getBounds().getCenter())
  // map.showLabel(label);
}


/*
==========================================
===END HELPER FUNCTIONS FOR MAP AND GEO===
==========================================
*/

/*
==========================================
==========================================
==========================================
==========END MAP & GEO SECTION===========
==========================================
==========================================
==========================================
*/
