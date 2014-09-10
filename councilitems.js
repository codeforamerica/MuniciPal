/*
==========================================
==========================================
==========================================
=======START COUNCIL ITEMS SECTION========
==========================================
==========================================
==========================================
*/

/*
==========================================
===TEMPLATES FOR COUNCIL ITEMS AND ICONS==
==========================================
*/

var legislationTemplate = $('#legislation-template').html();
Mustache.parse (legislationTemplate);  // optional, speeds up future uses

var eventTemplate = $('#event-details-template').html();
Mustache.parse (eventTemplate);  // optional, speeds up future uses

var attachmentsTemplate = $('#template-attachments').html();
Mustache.parse (attachmentsTemplate);

var icons = {
  'Contract': 'fa-pencil',
  'Resolution': 'fa-legal',
  'Liquor License': 'fa-glass',
  'miscellaneous': 'fa-cog',
  get: function(matterType) {
    return (this[matterType] ? this[matterType] : this['miscellaneous']);
  }
};

/*
==========================================
======END TEMPLATES FOR COUNCIL ITEMS=====
==========================================
*/

/*
==========================================
====HELPER FUNCTIONS FOR COUNCIL ITEMS====
==========================================
*/


function find_member(district) {
  return _.find(council, function(member){ return member.district == district });
}


/* convert text to paragraphs (newlines -> <p>s) */
/* modified from http://stackoverflow.com/questions/5020434/jquery-remove-new-line-then-wrap-textnodes-with-p */
function p(t){
    t = t.trim();
    return (t.length>0 ? '<p>'+t.replace(/[\r\n]+/g,'</p><p>')+'</p>' : null);
}

// returns a teaser (a shortened version of the text) and
// full body (which is the text itself).
// The teaser has a.readmore link which can be used to toggle which part is shown.
function summarize(text) {
  var short_text = 230;
  var breakpoint = short_text + 20; // we want to collapse more than just "last words in sentance."

  if (breakpoint < text.length) { // build a teaser and full text.
    var continueReading = '<a href="#" class="readmore"> &rarr; Continue Reading </a>';

    // regex looking for short_text worth of characters + whatever it takes to get to a whitespace
    // (we only want to break on whitespace, so we don't cut words in half)
    var re = new RegExp('.{' + short_text + '}\\S*?\\s');

    teaser = '<div class="teaser">' + p(text.match(re) + '&hellip;' + continueReading) + '</div>';
    body = '<div class="body">' + p(text) + '</div>';
    return teaser + body;
  } else { // short enough; no processing necessary
    return p(text);
  }
}

/*
==========================================
==END HELPER FUNCTIONS FOR PAGE LOADING===
==========================================
*/

/*
==========================================
==========================================
==========================================
=======END COUNCIL ITEMS SECTION==========
==========================================
==========================================
==========================================
*/
