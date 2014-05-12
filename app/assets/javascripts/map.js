var prj = 'codeforamerica.hmebo8ll';

var map = L.mapbox.map('map', prj)
	.setView([33.4019, -111.717], 12);

var DistrictLayer = L.mapbox.featureLayer(null, {fill: 'red'})
.addTo(map);

var marker = L.marker(new L.LatLng(33.4019, -111.717), {
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
      
      if (document.getElementById('legend-content'))
      {
        map.legendControl.removeLegend(document.getElementById('legend-content').innerHTML);
      }

      var stateObj = { foo: "bar" };
      var hasLegend = false;
      history.pushState(stateObj, "zone", "?address=" + data.address + "&lat=" + data.lat + "&long=" + data.lng);
      marker.setLatLng(new L.LatLng(data.lat, data.lng));
      // marker.bindPopup(new L.Popup()).openPopup();

      var DisStr = "";
      var DisStrPretty = "";
      var DistLegend = "";
      var DistColor = 'blue';
      if (data.in_district) {
        var geoJSON = $.parseJSON(data.district_polygon.st_asgeojson);
        geoJSON.properties= {};
        geoJSON.properties.fill = DistColor;
        DistrictLayer.setGeoJSON(geoJSON);
        DistrictLayer.setFilter(function() { return true; });
        DisStr = "<br>District: " + data.district_polygon.district;
        DisStrPretty =  "<p class=\"kicker\">Council District</p><p>District " + data.district_polygon.district + "</p>" +
                            "<p class=\"kicker\">Council Representative</p><p>" + data.district_polygon.name + "</p>";

        DistLegend = "<li><span style='background:" + DistColor + ";'></span>Council District</li>";
        hasLegend = true;
      }
      else {
        DistrictLayer.setFilter(function() { return false; });
      }

      // marker.setPopupContent("Address: " + data.address + DisStr + histDisStr);
      $( "div.results-container" ).replaceWith( 
          "<div class=\"results-container\"><div class=\"results-inner\"><h3>This is what we know about this address:</h3><p class=\"kicker\">Address</p><p>" + 
          data.address + "</p>" + DisStrPretty + "</div></div>" );
      // if (hasLegend)
      // {
      //   $("#legend-content").replaceWith("<div id='legend-content' style='display: none;'><ul class=\"ordering\">" +
      //     histDistLegend + 
      //     DistLegend + 
      //     "</ul><div class='legend-source'>Source: <a href=\"http://www.sanantonio.gov/GIS\">San Antonio GIS Data</a></div></div>");

      //   console.log(document.getElementById('legend-content').innerHTML);
      //   map.legendControl.addLegend(document.getElementById('legend-content').innerHTML);
      // }


      // var full_name = 'Dennis Ka....'; 
      var councilmember_first_name = data.district_polygon.name.split(' ')[0]; //data.district_polygon.name.split(" ")[0];
      var twitter_widget_id = data.district_polygon.twit_wdgt; //'465941592985968641'; //d
      var twitter_user = data.district_polygon.twit_name; // 'MesaDistrict3'; //

      $(".twit-widget").hide();
      $("#council-" + data.district_polygon.district).toggle();

      // $("#social").empty().append(
      //   '<h1 style="text-align: center;">Talk to ' + councilmember_first_name + '</h1>' +
      //   '<a class="twitter-timeline" href="https://twitter.com/' + twitter_user +'" data-widget-id="' + twitter_widget_id + '">Tweets by @' + twitter_user + '</a>'
        
      //   //"<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script>"
      // );



      $( "#address").val(data.address);
      map.setView([data.lat, data.lng], 15);
    }
  })
}

$( "#address" ).keyup(function(e) {
  if (e.keyCode == 13) { // enter pressed
    updateMarker({'address': $(this).val()});
  }
});
