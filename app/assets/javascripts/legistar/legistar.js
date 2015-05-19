// Legistar Classes

// globals
var Mustache, legislationTemplate, attachmentsTemplate, eventTemplate;

function Event(event) {
  this.event = event;
}

function EventItem(item, attachments) {

  // console.log("constructing eventItem: event_item_id:  " + item.id + ", matter_id: " + item.matter_id + ", event_id " + item.event_id);

  // set properties
  this.item = item;
  this.title = item.title;
  this.matter_type = item.matter_type;
  this.matter_name = item.matter_name;
  this.matter_id = item.matter_id;
  this.council_district = item.council_district_id;
  this.attachments = attachments;

  var icons = {
    'Contract': 'fa-pencil',
    'Resolution': 'fa-legal',
    'Liquor License': 'fa-glass',
    'miscellaneous': 'fa-cog'
  };
  this.icon = icons[this.matter_type] || icons.miscellaneous;


  this.improve_readability();
}

// render the view and add it to the DOM
// container: a jQuery selector string to which the rendered output should be attached
Event.prototype.render = function (container) {
  var that = this;
  var view = {
    date: function () {
      var months = [ "January", "February", "March", "April", "May", "June",
          "July", "August", "September", "October", "November", "December" ],
        date = that.event.date.replace(/T[\d:\.]*Z/, '').split('-'); //YYYY-MM-DDT00:00:00Z -> [yyyy,mm,dd]

      // EventDate doesn't come in the right format (timezone is 0 instead of -7), so we fix it
      var correctDate = new Date(date[0], date[1] - 1, date[2]);
      return months[correctDate.getMonth()] + ' ' + correctDate.getDate();
    },
    time: that.event.time,
    location: that.event.location,
    name: that.event.body_name,
    d: that.event.date,
  };
  // console.log(view);
  var eventHtml = Mustache.render(eventTemplate, view);
  // console.log("adding details to: " + container);
  $(container).html(eventHtml);
  return this;
};


/* text transforms on fields to improve readability of event items.
   Note that this works specifically with the way Mesa records things. */
EventItem.prototype.improve_readability = function () {
  // Simplify text by removing "(District X)" since we have that info elsewhere
  this.title = this.item.title.replace(/\(District \d\)/, '');

  var contract;
  // Contract Matters tend to look like "C12345 Something Human Friendly". Let's save & remove that contract #.
  if (this.item.matter_type === 'Contract') {
    contract = this.item.matter_name.split(' ')[0]; // save it
    // console.log("Got contract: " + contract);
    if (/C\d+/.test(contract)) {
      this.matter_name = this.item.matter_name.substr(this.item.matter_name.indexOf(' ') + 1); // remove it
    }
    // else {
    //   console.log("Weird. Expected " + contract + " to look like 'C' followed by some numbers.");
    // }
  }

  // We don't want to duplicate the MatterName (used as a title) as the first line of the text, so remove if found.
  var re = new RegExp('^' + this.item.matter_name + '[\n\r]*');
  this.title = this.item.title.replace(re, '');
};

// render the view and add it to the DOM
// container: a jQuery selector string to which the rendered output should be attached
/* jct - 05/2015 - change the title to use File Type instead of File Name - commented out orifinal fuction below */
EventItem.prototype.render = function (container) {
  var that = this;
  var view = {
      title: function () {
        var title;
          title = that.matter_type;
        }
        return title;
      },
      //jct beg of old one 
      /*
      var view = {
      title: function () {
        var title;
        if (that.matter_type === 'Ordinance' &&
            (/^Z\d{2}/.test(that.matter_name) ||
             /^Zon/.test(that.matter_name))) {
          title = "Zoning: " + that.matter_name;
        } else if (that.matter_type === "Liquor License") {
          title = "Liquor License for " + that.matter_name;
        } else if (that.matter_type === "Contract") {
          title = "Contract: " + that.matter_name;
        } else {
          title = that.matter_name;
        }
        return title;
      },
      */
      //jct end of old one
      
      distance: function () {
        return Math.floor(Math.random() * (6 - 2)) + 2; //TODO fixme
      },
      body: function () {
        return EventItem.summarize(that.title);
      },
      matterId: that.item.matter_id,
      eventItemId: that.item.id,
      icon: that.icon,
      scope: function () {
        var scope;
        if (that.council_district) {
          scope = "In District " + that.council_district;
        } else {
          scope = "Citywide";
        }
        return scope;
      }
    };

  var itemHtml = Mustache.render(legislationTemplate, view);
  $(container).append(itemHtml);
  return this.renderAttachments();
};

function toggleAttachments(event) {
  $(this).closest('.matter-attachments').find('ul.attachments').toggle();
  event.preventDefault();
}

EventItem.prototype.renderAttachments = function () {
  // get and populate matter attachments section
  var list = _.map(this.attachments, function (attachment) {
    return {
      link: attachment.hyperlink,
      name: attachment.name,
    };
  });
  if (list.length) {
    var view = {
      matterId: this.matter_id,
      attachmentCount: list.length,
      attachments: list,
    };
    var attachmentsHtml = Mustache.render(attachmentsTemplate, view);
    $('#attachments-' + this.item.id).html(attachmentsHtml);
    $('#attachments-' + this.item.id + ' a.attachments').click(toggleAttachments).click();
  } else {
    $('#attachments-' + this.item.id).html('<div class="attachments">No attachments</div>');
  }
  return this;
};



// returns a teaser (a shortened version of the text) and
// full body (which is the text itself).
// The teaser has a.readmore link which can be used to toggle which part is shown.
EventItem.summarize = function (text) {
  /* convert text to paragraphs (newlines -> <p>s) */
  /* modified from http://stackoverflow.com/questions/5020434/jquery-remove-new-line-then-wrap-textnodes-with-p */
  function p(t) {
    t = t.trim();
    return (t.length > 0 ? '<p>' + t.replace(/[\r\n]+/g, '</p><p>') + '</p>' : null);
  }

  var short_text = 230;
  var breakpoint = short_text + 20; // we want to collapse more than just "last words in sentance."

  var result;
  if (breakpoint < text.length) { // build a teaser and full text.
    var continueReading = '<a href="#" class="readmore"> &rarr; Continue Reading </a>';

    // regex looking for short_text worth of characters + whatever it takes to get to a whitespace
    // (we only want to break on whitespace, so we don't cut words in half)
    var re = new RegExp('^[\\s\\S]{' + short_text + '}\\S*?\\s');

    var teaser = '<div class="teaser">' + p(text.match(re) + '&hellip;' + continueReading) + '</div>';
    var body = '<div class="body">' + p(text) + '</div>';
    result = teaser + body;
  } else { // short enough; no processing necessary
    result = p(text);
  }
  return result;
};




