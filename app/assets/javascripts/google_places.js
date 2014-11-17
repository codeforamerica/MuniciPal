function googlePlacesInitialize() {
  var inputs;
  inputs = $('input[data-google-places]');
  return $.each(inputs, function() {
    return new google.maps.places.Autocomplete(this, {
      types: ['geocode'],
      componentRestrictions: {
        country: 'us'
      }
    });
  });
};

$(function() {
  return googlePlacesInitialize();
});
