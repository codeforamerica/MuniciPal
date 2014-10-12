// start point for the index page.

$(document).ready(function() {
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

	mapInitialize()

})