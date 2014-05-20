// mesa.js
// code specific to the mesa app

function toggleCards(event) {
	$('#contact-card').toggle();
	$('#twitter-card').toggle();
	console.log("toggling visibility of contacts/tweets")
	event.preventDefault();
}

$('#controls-contact').click(toggleCards);

$('#controls-twitter').click(toggleCards);