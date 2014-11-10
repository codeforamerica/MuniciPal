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

  // Revert to a previously saved state
  window.addEventListener('popstate', function(event) {
    console.log('popstate fired!');
    console.log(event);
    loadState(event.state);
  });

  app.district = response.district;
	mapInitialize();
	update_with_new(response);
}