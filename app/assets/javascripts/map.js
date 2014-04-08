    var prj = 'codeforamerica.hmebo8ll';
		var map = L.mapbox.map('map', prj)
    	.setView([29.423889, -98.493056], 12);

   var historicDistrictLayer = L.mapbox.featureLayer()
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
          marker.bindPopup(new L.Popup()).openPopup();
          var hisDisStr = "";
          if (data.in_district) {
            historicDistrictLayer.setGeoJSON($.parseJSON(data.district_polygon.st_asgeojson));
            historicDistrictLayer.setFilter(function() { return true; });
            hisDisStr = "<br>Historic District: " + data.district_polygon.name;
          }
          else {
            historicDistrictLayer.setFilter(function() { return false; });
          }
          marker.setPopupContent("Address: " + data.address + hisDisStr);
          map.setView([data.lat, data.lng], 15);
        }
      })
    }
    
    $( "#address" ).keyup(function(e) {
      if (e.keyCode == 13) { // enter pressed
        updateMarker({'address': $(this).val()});
      }
    });
