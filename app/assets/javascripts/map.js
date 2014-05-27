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

var g_data;


function find_member(district) {
  return _.find(council, function(member){ return member.district == district });
}


function updateMarker(d) {
  $.ajax({
    type: 'GET',
    url: '/',
    data: d,
    dataType: 'json',
    success: function( data ) {

      g_data = data;

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

        $('body').removeClass('initial');
        var district = data.district_polygon.district;

        var member = find_member(district);

        $('.results-text').empty().append(
          'You Live in District ' + district +
          '. <br> Your Council Representative is <a href="' + member.website + '">'  + data.district_polygon.name + '</a>.'
        );

        $('#contact-card .phone').empty().append(member.phone);
        $('#contact-card .email').empty().append(member.email);
        $('#contact-card .mail').empty().append(member.address);
        $('#contact-card .bio').empty().append(member.bio);



        // var full_name = 'Dennis Ka....';
        var councilmember_first_name = data.district_polygon.name.split(' ')[0]; //data.district_polygon.name.split(" ")[0];
        var twitter_widget_id = data.district_polygon.twit_wdgt; //'465941592985968641'; //d
        var twitter_user = data.district_polygon.twit_name; // 'MesaDistrict3'; //

        $(".twit-widget").hide();
        $("#council-" + data.district_polygon.district).toggle();
        $('#results-area').show();

      } else {

        DistrictLayer.setFilter(function() { return false; });
        $('.results-text').empty().append(
          'It looks like you\'re outside of Mesa.<br>' +
          'Maybe you want the <a href="http://www.mesaaz.gov/Council/">council webpage</a>?'
        );
        $('#results-area').hide();

      }

      $( "#address").val(data.address);
      map.setView([data.lat, data.lng], 12);
    }
  })
}


$( "#address" ).keyup(function(e) {
  if (e.keyCode == 13) { // enter pressed
    $( "#search-btn").click();
  }
});

$( "#search-btn" ).click(function(e) {
    updateMarker({'address': $( "#address" ).val()});
});
