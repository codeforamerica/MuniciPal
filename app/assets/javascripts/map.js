    var prj = 'codeforamerica.hmebo8ll';
		var map = L.mapbox.map('map', prj)
    	.setView([29.423889, -98.493056], 12);

   var historicDistrictLayer = L.mapbox.featureLayer()
   .addTo(map);
   var cosaDistrictLayer = L.mapbox.featureLayer(null, {fill: 'red'})
   .addTo(map);

   var marker = L.marker(new L.LatLng(29.423889, -98.493056), {
          icon: L.mapbox.marker.icon({'marker-color': 'CC0033'}),
          draggable: true
          });
    marker.addTo(map);

    marker.on('dragend', ondragend);

    function ondragend() {
        var ll = marker.getLatLng();
        updateMarker({'lat': ll.lat, 'long': ll.lng});
    }

    function updateMarker(d) {
      $.ajax({
        type: 'GET',
        url: '/',
        data: d,
        dataType: 'json',
        success: function( data ) {
          marker.setLatLng(new L.LatLng(data.lat, data.lng));
          // marker.bindPopup(new L.Popup()).openPopup();
          var histDisStr = "";
          var histDisStrPretty = "";
          if (data.in_hist_district) {
            var geoJSON = $.parseJSON(data.hist_district_polygon.st_asgeojson);
            console.log(geoJSON);
            geoJSON.properties= {};
            geoJSON.properties.fill = 'red';
            historicDistrictLayer.setGeoJSON(geoJSON);
            
            historicDistrictLayer.setFilter(function() { return true; });
            histDisStr = "<br>Historic District: " + data.hist_district_polygon.name;
            histDisStrPretty = "<p class=\"kicker\">Historic District</p><p>" + data.hist_district_polygon.name + "</p>"; 
          }
          else {
            historicDistrictLayer.setFilter(function() { return false; });
          }

          var cosaDisStr = "";
          var cosaDisStrPretty = "";
          if (data.in_cosa_district) {
            cosaDistrictLayer.setGeoJSON($.parseJSON(data.cosa_district_polygon.st_asgeojson));
            cosaDistrictLayer.setFilter(function() { return true; });
            cosaDisStr = "<br>COSA District: " + data.cosa_district_polygon.district +
                          "<br>City Council: " + data.cosa_district_polygon.name;
            cosaDisStrPretty =  "<p class=\"kicker\">Council District</p><p>District " + data.cosa_district_polygon.district + "</p>" +
                                "<p class=\"kicker\">Council Representative</p><p>" + data.cosa_district_polygon.name + "</p>";

          }
          else {
            cosaDistrictLayer.setFilter(function() { return false; });
          }

          // marker.setPopupContent("Address: " + data.address + cosaDisStr + histDisStr);
          $( "div.results-container" ).replaceWith( "<div class=\"results-container\"><div class=\"results-inner\"><h3>This is what we know about this address:</h3><p class=\"kicker\">Address</p><p>" + data.address + "</p>" + cosaDisStrPretty + histDisStrPretty + "</div></div>" );
          map.setView([data.lat, data.lng], 15);
        }
      })
    }
    
    $( "#address" ).keyup(function(e) {
      if (e.keyCode == 13) { // enter pressed
        updateMarker({'address': $(this).val()});
      }
    });
