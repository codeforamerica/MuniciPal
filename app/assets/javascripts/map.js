var prj = 'codeforamerica.hmebo8ll';

/* settings to change for different places. */
var MAP_CENTER_LOCATION = [33.4019, -111.717];
var MAP_MARKER_LOCATION = [33.42, -111.835];
var MAP_START_ZOOM = 12;
var DISTRICT_FILL = 'white';

// globals, for debugging
var g_data, g_districts;

var map = L.mapbox.map('map', prj)
	.setView(MAP_CENTER_LOCATION, MAP_START_ZOOM);

var districtLayer = L.mapbox.featureLayer(null, {}).addTo(map);
var otherDistrictsLayer;

var marker = L.marker(MAP_MARKER_LOCATION, {
      icon: L.mapbox.marker.icon({'marker-color': 'CC0033'}),
      draggable: true
      });
marker.addTo(map);
marker.on('dragend', onDragEnd);

var legislationTemplate = $('#legislation-template').html();
Mustache.parse (legislationTemplate);  // optional, speeds up future uses

var eventTemplate = $('#event-details-template').html();
Mustache.parse (eventTemplate);  // optional, speeds up future uses


function onDragEnd() {
    var ll = marker.getLatLng();
    updatePage({'lat': ll.lat, 'long': ll.lng});
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
    url: 'http://findlines.herokuapp.com/',
    data: { fileupload: text},
    dataType: 'json',
    success: linesToMap,
  });
}


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
        districtLayer.setGeoJSON(geoJSON);
        districtLayer.setFilter(function() { return true; });

        // HACK. this stuff should go in initializer on page load.
        // todo : on page load, hit a URL that will return just the districts. 
        addDistrictsToMap(data.districts);

        updatePageContent(data);

      } else {

        districtLayer.setFilter(function() { return false; });
        $('.you-live-in').empty().append(
          'It looks like you\'re outside of Mesa.<br>' +
          'Maybe you want the <a href="http://www.mesaaz.gov/Council/">council and mayor webpage</a>?'
        ).addClass("no-district").show();
        $('.results').hide();

      }

      $( "#address").val(data.address);
      map.setView([data.lat, data.lng], MAP_START_ZOOM);
    }
  })
}


function find_member(district) {
  return _.find(council, function(member){ return member.district == district });
}


var icons = {
  'Contract': 'fa-file-text',
  'Resolution': 'fa-legal',
  'Liquor License': 'fa-glass',
  'miscellaneous': 'fa-cog',
  get: function(matterType) {
    return (this[matterType] ? this[matterType] : this['miscellaneous']);
  }
};

/* convert text to paragraphs (newlines -> <p>s) */
/* modified from http://stackoverflow.com/questions/5020434/jquery-remove-new-line-then-wrap-textnodes-with-p */
function p(t){
    t = t.trim();
    return (t.length>0 ? '<p>'+t.replace(/[\r\n]+/g,'</p><p>')+'</p>' : null);
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
  // var councilmember_first_name = data.district_polygon.name.split(' ')[0]; //data.district_polygon.name.split(" ")[0];
  // var twitter_widget_id = data.district_polygon.twit_wdgt; //'465941592985968641'; //d
  // var twitter_user = data.district_polygon.twit_name; // 'MesaDistrict3'; //

  $(".twit-widget").hide();
  $(".twit-widget#council-" + district).show();
  $(".twit-widget#mention-" + district).show();

  $(".legislative-items").empty();

  // stick some event items in the frontend
  _.map(data.event_items, function(item) {
      textToGeo(item.EventItemTitle);

      var view = {
        title: function() {
          if (item.EventItemMatterType == 'Ordinance' &&
              (/^Z\d{2}.*/.test(item.EventItemMatterName) ||
               /^Zon.*/.test(item.EventItemMatterName))) {
            return "Zoning: " + item.EventItemMatterName;
          } else if (item.EventItemMatterType == "Liquor License") {
            return "Liquor License for " + item.EventItemMatterName;
          } else if (item.EventItemMatterType == "Contract") {
            return "Contract: " + item.EventItemMatterName;
          } else {
            return item.EventItemMatterName;
          }
        },
        body: function() {
          return p(item.EventItemTitle);
        },
        matterId: item.EventItemMatterId,
        icon: icons.get(item.EventItemMatterType),
      };

      var itemHtml = Mustache.render(legislationTemplate, view);
      $('.legislative-items').append(itemHtml);

      // get and populate matter attachments section
      $.ajax({
        type: 'GET',
        crossDomain: true,
        url: 'http://www.corsproxy.com/webapi.legistar.com/v1/mesa/Matters/' + item.EventItemMatterId + '/Attachments',
        dataType: 'json',
        success: function( data ) {

          var list = _.map(data, function (attachment) {
            return '<li><a href="' + attachment.MatterAttachmentHyperlink + '">' + attachment.MatterAttachmentName; + '</a></li>';
          }).join('');

          if (list.length) {
            var html = 'Attachments: <ul>' + list + '</ul>';
            $('#matter-' + item.EventItemMatterId).html(html);
          }
        },
      });

      // get and populate event details section
      $.ajax({
        type: 'GET',
        url: '/events/' + item.EventItemEventId + '.json',
        dataType: 'json',
        success: function( data ) {
          var view = {
            date: function() {
              var months = [ "January", "February", "March", "April", "May", "June", 
               "July", "August", "September", "October", "November", "December" ],
                date = data.EventDate.replace(/T.*Z/, '').split('-'); //YYYY-MM-DDT00:00:00Z -> [yyyy,mm,dd]

              // EventDate doesn't come in the right format (timezone is 0 instead of -7), so we fix it
               var correctDate = new Date(date[0], date[1] - 1, date[2]);
              return months[correctDate.getMonth()] + ' ' + correctDate.getDate();
            },
            time: data.EventTime,
            location: data.EventLocation,
            name: data.EventBodyName,
            d: data.EventDate,
          }
          console.log(view);
          var html = Mustache.render(eventTemplate, view);
          $('#event-details-' + item.EventItemMatterId).html(html);
        }
      });
  });

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
