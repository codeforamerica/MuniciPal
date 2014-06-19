var prj = 'codeforamerica.hmebo8ll';

var map = L.mapbox.map('map', prj)
	.setView([33.4019, -111.717], 12);

var DistrictLayer = L.mapbox.featureLayer(null, {fill: 'red'})
.addTo(map);

var marker = L.marker(new L.LatLng(33.42, -111.835), {
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

      var DistLegend = "";
      var DistColor = 'blue';

      if (data.in_district) {

        var geoJSON = $.parseJSON(data.district_polygon.st_asgeojson);
        geoJSON.properties= {};
        geoJSON.properties.fill = DistColor;
        DistrictLayer.setGeoJSON(geoJSON);
        DistrictLayer.setFilter(function() { return true; });

        DistLegend = "<li><span style='background:" + DistColor + ";'></span>Council District</li>";
        hasLegend = true;

        $('body').removeClass('initial');
        var district = data.district_polygon.id;

        var member = find_member(district);
        var mayor = find_member(0); // 0 = mayor. for now anyway.

        $('.you-live-in').empty().append('District ' + district).removeClass("no-district").show();
        $('.results-text').empty().append(
          'Your Council Representative is <a href="' + member.website + '">'  + data.district_polygon.name + '</a>.'
/*          '<br>(And you know about <a href="' + mayor.website + '">Mayor ' + mayor.name + '</a> and those <a href="' +
            mayor.twitter + '">tweets</a> right?)'*/
        );
        $('.results').show();

        $('#contact-card .phone').empty().append(member.phone);
        $('#contact-card .email').empty().append(member.email);
        $('#contact-card .mail').empty().append(member.address);
        $('#contact-card .bio').empty().append(member.bio);



        // var full_name = 'Dennis Ka....';
        var councilmember_first_name = data.district_polygon.name.split(' ')[0]; //data.district_polygon.name.split(" ")[0];
        var twitter_widget_id = data.district_polygon.twit_wdgt; //'465941592985968641'; //d
        var twitter_user = data.district_polygon.twit_name; // 'MesaDistrict3'; //

        $(".twit-widget").hide();
        $("#council-" + data.district_polygon.id).toggle();
        $("#mention-" + data.district_polygon.id).toggle();


        var icons = {
          'Contract': 'fa-file-text',
          'Resolution': 'fa-legal',
          'Liquor License': 'fa-glass',
          'miscellaneous': 'fa-cog',
          get: function(matterType) {
            console.log("looking up " + matterType);
            return (this[matterType] ? this[matterType] : this['miscellaneous']);
          }
        };

        function legislative_item_start(icon) {
          console.log("leg_item_start("+icon+")");
          return '<div class="legislation pure-g">\
            <div class="type pure-u-1 pure-u-md-1-8">\
                <i class="fa ' + icon + ' fa-2x"></i>\
            </div>\
            <div class="title pure-u-1 pure-u-md-17-24">';
        }

        var legislative_item_end = '</div>\
            <div class="like pure-u-1 pure-u-md-1-12">\
                <div class="fb-like post-footer-like" data-send="false" data-width="300" href="http://yerhere.herokuapp.com" data-show-faces="false" data-layout="button"></div>\
            </div>\
             <div class="comment pure-u-1 pure-u-md-1-12">\
                <a href="https://twitter.com/share" class="twitter-share-button" data-lang="en" data-url="http://localhost/citymatters/1" data-via="techieshark" data-text="@wfong_sf Let\'s talk about this. [INSERT COMMENT HERE]" data-related="buckley_tom:A really fun guy!,mesaazgov:The City of Mesa,MesaDistrict3:Your City Councilmember" data-hashtags="mesatalk" data-size="large" data-count="vertical">Tweet</a>\
            </div>\
        </div>';

        // stick some event items in the frontend
        var items = _.map(data.event_items, function(item) {
            return legislative_item_start(icons.get(item.EventItemMatterType)) + item.EventItemTitle + legislative_item_end;
        }).join('');
        $(".legislative-items").empty().append(items);

        // twitter & facebook only render on page load by default, so
        // we need to call on them to parse & render the new content
        twttr.widgets.load();
        FB.XFBML.parse(); // pass document.getElementById('legislative') for efficiency.

        $('#results-area').show();

      } else {

        DistrictLayer.setFilter(function() { return false; });
        $('.you-live-in').empty().append(
          'It looks like you\'re outside of Mesa.<br>' +
          'Maybe you want the <a href="http://www.mesaaz.gov/Council/">council and mayor webpage</a>?'
        ).addClass("no-district").show();
        $('.results').hide();

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
