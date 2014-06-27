var prj = 'codeforamerica.hmebo8ll';

/* settings to change for different places. */
var MAP_CENTER_LOCATION = [33.4019, -111.717];
var MAP_MARKER_LOCATION = [33.42, -111.835];
var MAP_STARTZOOM = 12;
var DISTRICT_FILL = 'white';

var map = L.mapbox.map('map', prj)
	.setView(MAP_CENTER_LOCATION, MAP_STARTZOOM);

var DistrictLayer = L.mapbox.featureLayer(null, {}).addTo(map);
var otherDistrictsLayer;

var marker = L.marker(MAP_MARKER_LOCATION, {
      icon: L.mapbox.marker.icon({'marker-color': 'CC0033'}),
      draggable: true
      });
marker.addTo(map);
marker.on('dragend', onDragEnd);

function onDragEnd() {
    var ll = marker.getLatLng();
    updatePage({'lat': ll.lat, 'long': ll.lng});
}

var g_data, g_districts;


function find_member(district) {
  return _.find(council, function(member){ return member.district == district });
}




function legislative_item_start(icon) {
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

var icons = {
  'Contract': 'fa-file-text',
  'Resolution': 'fa-legal',
  'Liquor License': 'fa-glass',
  'miscellaneous': 'fa-cog',
  get: function(matterType) {
    return (this[matterType] ? this[matterType] : this['miscellaneous']);
  }
};

/* Update the page, given a new lat/lng (ll). */
function updatePage(ll) {
  $.ajax({
    type: 'GET',
    url: '/',
    data: ll,
    dataType: 'json',
    success: function( data ) {

      g_data = data;

      history.pushState({}, "", "?address=" + data.address + "&lat=" + data.lat + "&long=" + data.lng);
      marker.setLatLng(new L.LatLng(data.lat, data.lng));

      if (data.in_district) {

        var geoJSON = $.parseJSON(data.district_polygon.st_asgeojson);
        geoJSON.properties = { fill: DISTRICT_FILL };
        DistrictLayer.setGeoJSON(geoJSON);
        DistrictLayer.setFilter(function() { return true; });

        // HACK. this stuff should go in initializer on page load.
        // todo : on page load, hit a URL that will return just the districts. 
        addDistrictsToMap(data.districts);

        updatePageContent(data);

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



function updatePageContent(data) {

  $('body').removeClass('initial');
  var district = data.district_polygon.id;

  var member = find_member(district);
  var mayor = find_member(0); // 0 = mayor. for now anyway.

  $('.you-live-in').empty().append('District ' + district).removeClass("no-district").show();
  $('.results-text').empty().append(
    'Your Council Representative is <a href="' + member.website + '">'  + data.district_polygon.name + '</a>.'
  /* '<br>(And you know about <a href="' + mayor.website + '">Mayor ' + mayor.name + '</a> and those <a href="' +
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
  $(".twit-widget#council-" + district).show();
  $(".twit-widget#mention-" + district).show();

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
  updatePage({'lat': e.latlng.lat, 'long': e.latlng.lng});
  console.log("jumping to district ");
}


function addDistrictsToMap(districts) {

  g_districts = otherDistrictsJSON = {
    type: "FeatureCollection",
    features: _.map(districts, function(district) {
      return {
        type: "Feature",
        geometry: jQuery.parseJSON(district.geom),
        properties: {
          name: district.name,
          twit_name: district.twit_name,
          twit_wdgt: district.twit_wdgt,
        },
        id: district.id,
      }
    }),
  };


  otherDistrictsLayer = L.geoJson(otherDistrictsJSON, {
    style: function (feature) {
      return {
          fillColor: DISTRICT_FILL,
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
}


$( "#address" ).keyup(function(e) {
  if (e.keyCode == 13) { // enter pressed
    $( "#search-btn").click();
  }
});

$( "#search-btn" ).click(function(e) {
    updatePage({'address': $( "#address" ).val()});
});
