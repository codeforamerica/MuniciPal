
function find_person(title, district) {
  if (title == 'mayor') {
    return find_mayor();
  } else if (title == 'manager') {
    return find_manager();
  } else {
    return find_councilmember('' + district);
  }
}

// function find_member(district) {
//   return _.find(people, { 'district': district });
// }
function find_councilmember(district) {
  return _.find(people, { 'district': district });
}

function find_mayor() {
  return _.find(people, { 'title': 'Mayor' })
}

function find_manager() {
  return _.find(people, { 'title': 'City Manager' })
}

function Person(person) {
  this.person = person;
}

Person.prototype.title = function() {
  switch (this.person.title) {
    case 'City Councilmember': return 'District ' + this.person.district;
    default: return this.person.title;
  }
}

// takes a platform name ('twitter', etc) and returns the platform details.
Person.prototype.socialDetails = function(platform) {
  return _.find(this.person.social, {platform: platform});
}

// render the Person and attach it to the element found at `container`, a CSS selector (e.g. an #id)
//
Person.prototype.render = function(container) {

  var that = this;

  // var eventHtml = Mustache.render(eventTemplate, view);
  // console.log("adding details to: " + container);
  // $(container).html(eventHtml)


  var who_view = {
    district: that.person.district,
    pic: {
      src: that.person.photo_url
    },
    name: that.person.name.fullname,
    phone: that.person.phone,
    email: that.person.email,
    website: that.person.website_url,
    bio: that.person.bio,
    facebook: function() {
      // try to find social network if it exists in data
      social = that.socialDetails('facebook');
      if (typeof social != 'undefined') {
        return social.name;
      }
    },
    twitterName: function() {
      social = that.socialDetails('twitter');
      if (typeof social != 'undefined') {
        return social.name
      }
    },
    twitterWidget: function() {
      social = that.socialDetails('twitter');
      if (typeof social != 'undefined') {
        return social.widget || "465935532589993984"; // provide default if none given
      }
    }
  };

  if (this.socialDetails('facebook')) {
    $('#facebook-card').html(Mustache.render(facebookTemplate, who_view));
  } else {
    $('#facebook-card').html(Mustache.render(noFacebookTemplate));
  }

  if (this.socialDetails('twitter')) {
    $('#twitter-card').html(Mustache.render(twitterTemplate, who_view));
  } else {
    $('#twitter-card').html(Mustache.render(noTwitterTemplate));
  }


  $('.person-title').empty().append(this.title()).removeClass("no-district").show(); // TODO remove no-district stuff
  $('#results, #person').show();

  $('#person-picture').attr({
    'src': this.person.photo_url,
    'alt': 'Photo of ' + this.person.name.fullname
  });
  $('#person-name').text(this.person.name.fullname);
  $('#person-phone').text(this.person.phone);
  $('#person-email').text(this.person.email);
  $('#person-website').text(this.person.website_url);
  $('#bio-card').text(this.person.bio);

  return this;
}
