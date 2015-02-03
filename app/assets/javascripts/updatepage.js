
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

var app = app || {};


app.maybeRenderFacebook = function() {

  if ('renderedFacebook' in app) {
    console.debug("Facebook widget already rendered; skipping re-render");
  } else if ((('FB' in window) && ('XFBML' in FB)) && ($('#facebook-card .fb-widget').length > 0))
  {
    // we know now that FB API is loaded & the necessary DOM element exists
    console.debug("attempting to render Facebook widget");
    FB.XFBML.parse($('#facebook-card')[0]);
    app.renderedFacebook = true;
  } else {
    console.debug("not quite ready to render Facebook widget; skipping for now");
  }
};

var loadState = function (state) {
  if (state && state.firstState === true) {
    console.log("page reload");
    window.location.reload(); // reload from cache if user navigates back to first page
  } else if (state) {
    console.log('loading existing state: ');
    console.log(state);
    update_with_new(state.data);
  } else {
    // Safari and pre v34 Chrome always emit popstate event on page load; ignore it
    // https://developer.mozilla.org/en-US/docs/Web/Events/popstate
  }
}


// Request new data from the server and update the page based on the result.
// params should be a hash with keys like `address` or `lat` & `lng`.
function updatePage(params) {
  $.ajax({
    type: 'GET',
    url: '/',
    data: params,
    dataType: 'json',
    success: update_from_ajax
  });
}


function update_with_new( data ) {
  console.debug("rendering page via update_with_new()");

  if (!data.event_items) { return; } // must be at root w/ no data yet

  app.data = data;

  if (data.in_district) {

    if (data.person_title == "councilmember") {
      app.district = data.district;
      highlightCurrentDistrict();

      if (typeof data.lat !== "undefined" && data.lat) {
        marker.setLatLng([data.lat, data.lng]);
      }
    }

    updatePageContent(data);

  } else {

    districtLayer.setFilter(function() { return false; });
    $('.person-position').empty().append(
      'It looks like you\'re outside of Mesa.<br>' +
      'Maybe you want the <a href="http://www.mesaaz.gov/Council/">council and mayor webpage</a>?').addClass("no-district").show();
    $('#results').hide();

  }

  var showaddress = data.address || "";
  $("#address").val(showaddress);
  document.getElementById('results').scrollIntoView();
}


var update_from_ajax = function (data) {

  var url;
  if (typeof data.address !== "undefined" && data.address) {
    url = "/?address=" + data.address;
  } else if (typeof data.lat !== "undefined" && data.lat && data.lng) {
    // note that we specify these in lng,lat order (not vice versa) to workaround
    // an apparent chrome bug very similar to the one described here:
    // https://code.google.com/p/chromium/issues/detail?id=108766#c5
    // and https://groups.google.com/forum/#!topic/angular/N4etYJwL63c
    // For us, the bug was:
    // 1. Go to homepage.
    // 2. Drag the marker to a district on the map (ex: District 1)
    // 3. Select a different district from the menu (ex: District 2)
    // 4. Click back. You should see District 1 but instead you'd see a js object.
    // Basically this workaround's strategy is to make the url look different
    // for the page than for the REST request, so Chrome doesn't request the REST object
    // and stick it in the browser's window.
    url = "/?lng=" + data.lng + "&lat=" + data.lat;
  }
  if (url) {
    // only when update_with_new is called from updatePage do we pushState.
    // all other times, history should be handled by the browser.
    history.pushState({'data': data}, "", url);
  }

  update_with_new(data);
};


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

  if (typeof data.district !== "undefined" &&
      data.district != 'all') {
    var district = data.district;
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

  $('#results-area').show();
}
