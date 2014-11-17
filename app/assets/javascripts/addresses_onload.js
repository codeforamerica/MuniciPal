// start point for the index page.

var indexDocReady = function (response) {
	$( "#address" ).keyup(function(e) {
	  if (e.keyCode == 13) { // enter pressed
	    $( "#search-btn").click();
	  }
	});

	// the updatePage function can be found in
	// updatepage.js
	$( "#search-btn" ).click(function(e) {
	    updatePage({'address': $( "#address" ).val()});
	});

	$('#controls-bio').click(toggleCards);
	$('#controls-twitter').click(toggleCards);
	$('#controls-facebook').click(toggleCards);

	// initally we want to show just the bio card
	$('#cards .card').hide();
	$('#cards #bio-card').show();

  app.district = response.district;
	mapInitialize();
	update_with_new(response);
}