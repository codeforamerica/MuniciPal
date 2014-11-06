
/*
UPDATEPAGE() IS CALLED ON USER ADDRESS ENTRY
OR USER MAP MARKER DRAGGING

IT UPDATES THE MAP AND THE COUNCIL ITEMS

This function is called from the main landing page through a JQuery function in addresses.js
It makes a get request to the Addresses controller with:
  -the user-entered Address, or
  -a Latitude and Longitude pair
   (from the map and map.js onDragEnd function)

The Addresses Controller returns the "data" object, an example of which can be found below:

{
  "lat": 33.3781823,
  "lng": -111.8430479,
  "address": "455 West Baseline Road, Mesa, AZ 85210, USA",
  "in_district": true,
  "district_polygon": A PostGIS GeoJSON object,
  "districts": Array of PostGIS GeoJSON objects,
  "event_items": Array
}

Example of item from event_items Array:

{
  "id":34418,
  "source_id":34418,
  "council_district_id":3,
  "event_id":1940,
  "matter_id":7205,
  "guid":"EDB83D77-6ACF-4602-9FDA-2902A2D5B486",
  "last_modified_utc":"2014-09-09T02:55:40.930Z",
  "row_version":"AAAAAAAxwmY=",
  "agenda_sequence":15,
  "minutes_sequence":15,
  "agenda_number":"3-f",
  "video":null,
  "video_index":null,
  "version":"1",
  "agenda_note":null,
  "minutes_note":null,
  "action_id":null,
  "action_name":null,
  "action_text":null,
  "passed_flag":null,
  "passed_flag_name":null,
  "roll_call_flag":0,
  "flag_extra":0,
  "title":" \r\nA restaurant that serves lunch and dinner is requesting a new Series 12 Restaurant License for Red Lobster Hospitality LLC, 1403 South Alma School Road - Richard Teel, agent.  The existing license held by N&D Restaurants Inc., will revert back to the State. ",
  "tally":null,
  "consent":0,
  "mover_id":null,
  "mover":null,
  "seconder_id":null,
  "seconder":null,
  "matter_guid":"80028133-D9BB-4DA0-BD39-A2C1CFBFEBE3",
  "matter_file":"14-0910",
  "matter_name":"Red Lobster #6219",
  "matter_type":"Liquor License",
  "matter_status":"Agenda Ready",
  "created_at":"2014-09-12T07:32:12.000Z",
  "updated_at":"2014-09-12T07:32:18.426Z"
}

*/


// Request new data from the server and update the page based on the result.
// params should be a hash with keys like `address` or `lat` & `long`.
function updatePage(params) {
  $.ajax({
    type: 'GET',
    url: '/',
    data: params,
    dataType: 'json',
    success: update_with_new
  });
}

function update_with_new( data ) {

  if (!data.event_items) { return; } // must be at root w/ no data yet

  g_data = data;

  if (data.in_district) {

    if (data.person_title == "councilmember") {
      history.pushState({}, "", "?address=" + data.address + "&lat=" + data.lat + "&long=" + data.lng);
      marker.setLatLng(new L.LatLng(data.lat, data.lng));
      var district = _.find(districts, { id: data.district_id });
      var geoJSON = $.parseJSON(district.geom);
      geoJSON.properties = { fill: config.map.district_fill };
      districtLayer.setGeoJSON(geoJSON);
      districtLayer.setFilter(function() { return true; });
    }

    updatePageContent(data);

  } else {

    districtLayer.setFilter(function() { return false; });
    $('.person-position').empty().append(
      'It looks like you\'re outside of Mesa.<br>' +
      'Maybe you want the <a href="http://www.mesaaz.gov/Council/">council and mayor webpage</a>?').addClass("no-district").show();
    $('#results').hide();

  }

  $( "#address").val(data.address);
  map.setView([data.lat, data.lng], config.map.start_zoom);
  document.getElementById('results').scrollIntoView();
}


function setPageClickHandlers() {

  $('.legislative-items a.readmore').click(function(event) {
    // toggle visibility of the clicked teaser and body.
    event.preventDefault();
    legislation = $(this).closest('.title');
    legislation.find('.teaser').toggle();
    legislation.find('.body').toggle();
  });

  $('a.comments').click(function(event) {
    event.preventDefault();
    // get the matter id
    var matter = $(this).attr('data-matter-id');
    console.log("clicked matter: " + matter);

    var element;
    if ($('#disqus_thread').length === 0) {
      // element = document.create("div").attr('id', 'disqus_thread');
      element = document.createElement('div');
      element.setAttribute('id', 'disqus_thread');
    } else {
      $('#disqus_thread').parent().hide();
      element = $('#disqus_thread').detach();
    }

    // append either the element if it exists or a new disqus_thread element.
    $(this).closest('.legislation').find('div.comments').append(element).show();

    disqusInitialize(matter);
  });
}


/*
This function fills out a bunch of mustache templates from the data above and AJAX
requests to the legistar REST API.
 */

function updatePageContent(data) {

  $('body').removeClass('initial');

  if (data.district_id != 'all') {
    var district = data.district_id;
    var member = find_person(data.person_title, district);
    var person = new Person(member).render('#person');
  }

  $(".legislative-items").empty();

  // stick some event items in the frontend
  _.map(data.event_items, function(item, i) {

      // textToGeo(item.title);

      var event_item = new EventItem(item, data.attachments[i]).render('.legislative-items');

      // get and populate event details section
      var api_event = _.find(data.events, {id: item.event_id});
      event = new Event(api_event).render('#event-details-' + event_item.item.source_id);

  });

  $('#results, #legislative').show();

  setPageClickHandlers();

  // When necessary, force twitter and facebook widgets to reload.
  // By default, twitter & facebook only render when the page first loads.
  // If these objects exist (the page has already been loaded), and we're
  // attempting to update the page (e.g. when a new location is selected),
  // then after we build and attach the HTML they expect to the DOM, we need
  // to call on them to parse the HTML we've attached above and load actual
  // social media content.
  if ('twttr' in window && 'widgets' in twttr) {
    twttr.widgets.load();
  }
  if ('FB' in window && 'XFBML' in FB) {
    FB.XFBML.parse(); // pass document.getElementById('legislative') for efficiency.
  }


  $('#results-area').show();
}
