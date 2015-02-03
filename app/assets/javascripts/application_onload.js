// stuff we want to happen on load for every page

var app = app || {};

var legislationTemplate, eventTemplate, attachmentsTemplate;

$(document).ready(function() {

	facebookTemplate = $('#facebook-template').html();
	Mustache.parse (facebookTemplate);

	noFacebookTemplate = $('#no-facebook-template').html();
	Mustache.parse (noFacebookTemplate);

	twitterTemplate = $('#twitter-template').html();
	Mustache.parse (twitterTemplate);

	noTwitterTemplate = $('#no-twitter-template').html();
	Mustache.parse (noTwitterTemplate);

	legislationTemplate = $('#legislation-template').html();
	Mustache.parse (legislationTemplate);  // optional, speeds up future uses

	eventTemplate = $('#event-details-template').html();
	Mustache.parse (eventTemplate);  // optional, speeds up future uses

	attachmentsTemplate = $('#template-attachments').html();
	Mustache.parse (attachmentsTemplate);


	$.ajaxSetup({ cache: true });
	console.debug("fetching Facebook API");
	$.getScript('//connect.facebook.net/en_US/sdk.js', function(){
		FB.init({
		  appId: '612274872174090',
		  version: 'v2.2',
		  xfbml: false,
		});
		console.debug('finished fetching Facebook API');
		app.maybeRenderFacebook();
	});

});
