
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

        var geoJSON = $.parseJSON(data.district_polygon.geom);

        geoJSON.properties = { fill: config.map.district_fill };
        districtLayer.setGeoJSON(geoJSON);
        districtLayer.setFilter(function() { return true; });

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
      map.setView([data.lat, data.lng], config.map.start_zoom);
      document.getElementById('answer').scrollIntoView();
    }
  })
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

    disqusInitialize(matter);
  });
}


/*
This function fills out a bunch of mustache templates from the data above and AJAX
requests to the legistar REST API.
 */

function updatePageContent(data) {

  $('body').removeClass('initial');
  var district = data.district_polygon.id;

  var member = find_member(district);
  var mayor = find_member(0); // 0 = mayor. for now anyway.

  $('.you-live-in').empty().append('District ' + district).removeClass("no-district").show();
  $('.results-text').empty().append(data.district_polygon.name);
  $('.results').show();

  $('#council-picture').attr({
    'src': 'http://tomcfa.s3.amazonaws.com/district'+district+'.jpg',
    'alt': 'Councilmember for District ' + district
  });
  $('#council-member').text(data.district_polygon.name);
  $('#council-phone').text(member.phone);
  $('#council-email').text(member.email);
  $('#council-website').text(member.website);
  $('#council-address').text(member.address);
  $('#bio-card .bio').text(member.bio);


  $(".fb-widget").hide();
  $(".fb-widget#facebook-" + district).show();


  $(".twit-widget").hide();
  $(".twit-widget#council-" + district).show();
//  $(".twit-widget#mention-" + district).show();

  $(".legislative-items").empty();

  // stick some event items in the frontend
  _.map(data.event_items, function(item, i) {

      textToGeo(item.title);

      var event_item = new EventItem(item, data.attachments[i]).render('.legislative-items')

      // get and populate event details section
      var api_event = _.find(data.events, {id: item.event_id})
      event = new Event(api_event).render('#event-details-' + event_item.matter_id)

  });

  setPageClickHandlers();

  // twitter & facebook only render on page load by default, so
  // we need to call on them to parse & render the new content
  twttr.widgets.load();
  FB.XFBML.parse(); // pass document.getElementById('legislative') for efficiency.

  $('#results-area').show();
}
