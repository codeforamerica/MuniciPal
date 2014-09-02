var prj = 'codeforamerica.hmebo8ll'; // Mapbox map id string

/* settings to change for different places. */
var MAP_CENTER_LOCATION = [33.4019, -111.78];
var MAP_MARKER_LOCATION = [33.42, -111.835];
var MAP_START_ZOOM = 12;
var DISTRICT_FILL = 'white';

// globals, for debugging
var g_data, g_districts;

var map = L.mapbox.map(
  'map', 
  prj, 
  { 
    center: MAP_CENTER_LOCATION,
    zoom: MAP_START_ZOOM,
    minZoom: 6,
    maxZoom: 18,
    scrollWheelZoom: false,
  }
);

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

var attachmentsTemplate = $('#template-attachments').html();
Mustache.parse (attachmentsTemplate);

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
      document.getElementById('answer').scrollIntoView();
    }
  })
}


function find_member(district) {
  return _.find(council, function(member){ return member.district == district });
}


var icons = {
  'Contract': 'fa-pencil',
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

// returns a teaser (a shortened version of the text) and
// full body (which is the text itself).
// The teaser has a.readmore link which can be used to toggle which part is shown.
function summarize(text) {
  var short_text = 230;
  var breakpoint = short_text + 20; // we want to collapse more than just "last words in sentance."

  if (breakpoint < text.length) { // build a teaser and full text.
    var continueReading = '<a href="#" class="readmore"> &rarr; Continue Reading </a>';

    // regex looking for short_text worth of characters + whatever it takes to get to a whitespace
    // (we only want to break on whitespace, so we don't cut words in half)
    var re = new RegExp('.{' + short_text + '}\\S*?\\s');

    teaser = '<div class="teaser">' + p(text.match(re) + '&hellip;' + continueReading) + '</div>';
    body = '<div class="body">' + p(text) + '</div>';
    return teaser + body;
  } else { // short enough; no processing necessary
    return p(text);
  }
}


function updatePageContent(data) {

  $('body').removeClass('initial');
  var district = data.district_polygon.id;

  var member = find_member(district);
  var mayor = find_member(0); // 0 = mayor. for now anyway.

  $('.you-live-in').empty().append('District ' + district).removeClass("no-district").show();
  $('.results-text').empty().append(data.district_polygon.name);
  $('.results').show();

  $('#council-picture').attr({
    'src': '/assets/district'+district+'.jpg',
    'alt': 'Councilmember for District ' + district
  });
  $('#council-member').empty().append(data.district_polygon.name);
  $('#council-phone').empty().append(member.phone);
  $('#council-email').empty().append(member.email);
  $('#council-website').empty().append(member.website);
  $('#council-address').empty().append(member.address);
  $('#bio-card .bio').empty().append(member.bio);

  $(".fb-widget").hide();
  $(".fb-widget#facebook-" + district).show();


  $(".twit-widget").hide();
  $(".twit-widget#council-" + district).show();
//  $(".twit-widget#mention-" + district).show();

  $(".legislative-items").empty();

  // stick some event items in the frontend
  _.map(data.event_items, function(item) {

      // ---- transforms -------------------------------------------------------------

      // Simplify text by removing "(District X)" since we have that info elsewhere
      item.EventItemTitle = item.EventItemTitle.replace(/\(District \d\)/, '');

      var contract;
      // Contract Matters tend to look like "C12345 Something Human Friendly". Let's save & remove that contract #.
      if (item.EventItemMatterType == 'Contract') {
        contract = item.EventItemMatterName.split(' ')[0]; // save it
        console.log("Got contract: " + contract);
        if (/C\d+/.test(contract)) {
          item.EventItemMatterName = item.EventItemMatterName.substr(item.EventItemMatterName.indexOf(' ') + 1); // remove it
        } else {
          console.log("Weird. Expected " + contract + " to look like 'C' followed by some numbers.");
        }
      }

      // We don't want to duplicate the MatterName (used as a title) as the first line of the text, so remove if found.
      var re = new RegExp('^' + item.EventItemMatterName + '[\n\r]*');
      item.EventItemTitle = item.EventItemTitle.replace(re, '');

      // ---- end transforms ----------------------------------------------------------


      textToGeo(item.EventItemTitle);

      console.log("constructing legislative item");
      console.log(item.EventItemMatterId);

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
        distance: function () {
          return Math.floor(Math.random() * (6 - 2)) + 2;
        },
        body: function() {
          return summarize(item.EventItemTitle);
        },
        matterId: item.EventItemMatterId,
        icon: icons.get(item.EventItemMatterType),
        scope: function() {
          // if Citywide, "Citywide" (TODO), else
          return "In District " + district;
        }
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
            return {
              link: attachment.MatterAttachmentHyperlink,
              name: attachment.MatterAttachmentName,
            };
          });

          if (list.length) {
            var view = {
              matterId: item.EventItemMatterId,
              attachmentCount: list.length,
              attachments: list,
            };
            var html = Mustache.render(attachmentsTemplate, view);
            $('#attachments-' + item.EventItemMatterId).html(html);
            $('#attachments-' + item.EventItemMatterId + ' a.attachments').click(function(event) {
              var matterId = $(this).attr('data-matter-id');
              console.log("setting link handler for attachments on matter " + matterId + "(matter " + item.EventItemMatterId + ")");
              $('#attachments-' + matterId + ' ul.attachments').toggle();
              event.preventDefault();
            }).click();
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
                date = data.EventDate.replace(/T.*/, '').split('-'); //YYYY-MM-DDT00:00:00Z -> [yyyy,mm,dd]

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
          console.log("adding details to event item");
          console.log(item.EventItemMatterId);

          $('#event-details-' + item.EventItemMatterId).html(html);
        }
      });
  });

  $('.legislative-items a.readmore').click(function(event) {
    // toggle visibility of the clicked teaser and body.
    event.preventDefault();
    legislation = $(this).closest('.title');
    legislation.find('.teaser').toggle();
    legislation.find('.body').toggle();
  });

  $('a.comments').click(function(event) {
    event.preventDefault()
    // get the matter id
    var matter = $(this).attr('data-matter-id')
    console.log("clicked matter: " + matter)

    var element;
    if ($('#disqus_thread').length == 0) {
      // element = document.create("div").attr('id', 'disqus_thread');
      element = document.createElement('div');
      element.setAttribute('id', 'disqus_thread')
    } else {
      $('#disqus_thread').parent().hide()
      element = $('#disqus_thread').detach();
    }

    var selectedCommentDiv = $('#' + matter).find('div.comments');
    // append either the element if it exists or a new disqus_thread element.
    // selectedCommentDiv.append(element.length > 0 ? element : "<div id='disqus_thread'></div>");
    selectedCommentDiv.append(element);

    selectedCommentDiv.show();

    DISQUS.reset({
      reload: true,
      config: function () {  
        this.page.identifier = matter;  
        this.page.url = "http://yerhere.herokuapp.com/matters/" + matter;
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
