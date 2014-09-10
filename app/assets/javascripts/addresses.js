//= require vendor/tabletop.js
//= require vendor/underscore.js
//= require vendor/mustache.js
//= require councilitems.js
//= require map.js
//= require pageupdate.js
//= require processurl.js
//= require mesa.js
//= require disqus.js

$( "#address" ).keyup(function(e) {
  if (e.keyCode == 13) { // enter pressed
    $( "#search-btn").click();
  }
});

$( "#search-btn" ).click(function(e) {
    updatePage({'address': $( "#address" ).val()});
});
