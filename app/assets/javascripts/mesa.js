// mesa.js
// code specific to the mesa app

// show just the card that is associated with the tab that was clicked
function toggleCards(event) {
    event.preventDefault();

    // if the currently selected card was clicked, nothing to do; ignore click.
    if ($(this).parent().hasClass('pure-menu-selected')) {
        console.log('ignoring useless click');
        return;
    }

    $('#cards .card').hide();
    var selected = $(this).attr('data-card');
    $('#' + selected).show();

    $(this).parent().parent().find('.pure-menu-selected').removeClass('pure-menu-selected');
    $(this).parent().addClass('pure-menu-selected');
}


// example code from https://github.com/jsoma/tabletop

// window.onload = function() { init() };

// var public_spreadsheet_url = 'https://docs.google.com/spreadsheet/pub?hl=en_US&hl=en_US&key=0AmYzu_s7QHsmdDNZUzRlYldnWTZCLXdrMXlYQzVxSFE&output=html';

// function init() {
// 	Tabletop.init(
// 		{ key: '16XlcsycmfTtTed-5HAPN0LMcMxIEYiWl7pJvCQTm6x4',
// 	         callback: showInfo,
// 	         simpleSheet: true 
// 	    });
// }

// function showInfo(data, tabletop) {
// 	alert("Successfully processed!")
// 	console.log(data);
// }

// (function init_kodos() {

//     // initialize the kudoer
//     $("figure.kudo").kudoable();

//     // bind to events on the kudos
//     $("figure.kudo").on("kudo:added", function(event)
//     {
//       var element = $(this);
//       var id = element.data('id');
//       // send the data to your server...
//       console.log("Kudod!", element);
//     });
// })();

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
  return _.find(people, { 'title': 'mayor' })
}

function find_manager() {
  return _.find(people, { 'title': 'city manager' })
}

var people = [
  {
      "name": "John Giles",
      "title": "mayor",
      "district": "n/a",
      "bio": "a mayor... todo...",
      "phone": "480-644-XXXX",
      "email": "XXX@mesaaz.gov",
      "facebook": "MesaMayorsOffice",
      "twitterName": "MesaMayorOffice",
      "twitterWidget": "465935532589993984",
      "website": "http://www.mesaaz.gov/mayor",
      "photo": "http://www.mesaaz.gov/mayor/images/GilesHeadshot.jpg"
  },
  {
      "name": "Chris Brady",
      "title": "city manager",
      "district": "n/a",
      "bio": "a manager... todo...",
      "phone": "480-644-XXXX",
      "email": "XXX@mesaaz.gov",
      "facebook": "n/a",
      "twitterName": "n/a",
      "twitterWidget": "",
      "website": "http://www.mesaaz.gov/mayor",
      "photo": "https://raw.githubusercontent.com/techieshark/council-info/master/img/Chris_Brady.jpg"

  }
]

var council = [
    {
        "name": "Dave Richins",
        "district": 1,
        "bio": "Elected to the Mesa City Council in June of 2008 and re-elected in August of 2012, Dave Richins serves as the councilmember for District 1. His term on the Mesa City Council runs until January 2017.\nRichins is the principal government affairs advisor for Resolution Copper Mining, LLC. His duties include engaging federal, state and local officials for legal clearances that would allow the company to mine for copper just east of Superior, Arizona.\nHe is Chair of the Mesa City Council Community and Cultural Development committee and serves on the Council Economic Development committee and the Council Government Affairs committee as well as Chair of the City of Mesa Employee Benefits Advisory committee.  He is Board Liaison for the Mesa Chamber of Commerce and is also one of the Council representatives to the West Mesa Community Development Corporation (ex Officio).",
        "phone": "480-644-4002",
        "email": "District1@mesaaz.gov",
        "fax": "480-644-2175",
        "facebook": "CouncilmemberDaveRichins",
        "twitterName": "dlrichins",
        "twitterWidget": "465935532589993984",
        "address": "P.O. Box 1466 Mesa, AZ 85211-1466",
        "assistant": "Alicia White",
        "assistantphone": "480-644-5296",
        "assistantemail": "alicia.white@mesaaz.gov",
        "website": "http://www.mesaaz.gov/council/richins",
        "photo": "http://tomcfa.s3.amazonaws.com/district1.jpg"
    },
    {
        "name": "Terry Benelli",
        "district": 2,
        "bio": "Benelli has lived in Mesa for 28 years and is the owner of a Home Owners Association management company. She also spent seven years as the Executive Director of the Neighborhood Economic Development Corporation (NEDCO) in downtown Mesa. Benelli has a Bachelor of Arts in Political Science from Arizona State University and earned a Flinn-Brown Civic Leadership Fellowship from the Arizona Center for Civic Leadership. She is also a 2001 graduate of the Mesa Leadership Training and Development program.",
        "phone": "480-644-3772",
        "email": "councilmember.benelli@mesaaz.gov",
        "fax": "480-644-2175",
        "facebook": "CouncilmemberBenelli",
        "twitterName": "MesaDistrict2",
        "twitterWidget": "465941398470922240",
        "address": "P.O. Box 1466\nMesa, AZ 85211-1466",
        "assistant": "Ian Linssen",
        "assistantphone": "480-644-5295",
        "assistantemail": "ian.linssen@mesaaz.gov",
        "website": "http://www.mesaaz.gov/council/benelli/",
        "photo": "http://tomcfa.s3.amazonaws.com/district2.jpg"

    },
    {
        "name": "Dennis Kavanaugh",
        "district": 3,
        "bio": "Elected to the Mesa City Council in June of 2008 and re-elected in August of 2012, Dennis Kavanaugh serves as the councilmember for District 3. Kavanaugh is the founder of the law firm Dennis Kavanaugh, P.C., one of Arizona's leading social security and worker's compensation law firms. His term on the Mesa City Council runs until January of 2017. Kavanaugh was also a member of the City Council from 1996 to 2004, serving as Vice Mayor from 2002 until 2004.",
        "phone": "480-644-3003",
        "email": "District3@mesaaz.gov",
        "fax": "480-644-2175",
        "facebook": "councilmember.kavanaugh",
        "twitterName": "MesaDistrict3",
        "twitterWidget": "465941592985968641",
        "address": "P.O. Box 1466 \nMesa, AZ 85211-1466",
        "assistant": "Jared Archambault",
        "assistantphone": "480-644-6275",
        "assistantemail": "jared.archambault@mesaaz.gov",
        "website": "http://www.mesaaz.gov/council/kavanaugh",
        "photo": "http://tomcfa.s3.amazonaws.com/district3.jpg"

    },
    {
        "name": "Christopher Glover ",
        "district": 4,
        "bio": "Serving his first term representing Mesa's District 4, Vice Mayor Chris Glover became the youngest person ever to serve on the Mesa City Council following his election in 2011. He was named Vice Mayor on April 21, 2014. Glover is a native of Mesa, attending Mesa Public Schools, graduating with honors from Mesa High School and he was a member of the Mayor's Youth Committee. While at Arizona State as an undergrad, Glover earned certificates in both Latin American Studies and International Studies and was a Capitol Scholar and Junior Fellow. He also studied at Universidad de Torcuato di Tella in Buenos Aires, Argentina. Glover earned a degree in Political Science with minors in History and Spanish from Arizona State University. He also spent a summer in Washington, D.C. as an intern for Senator John Ensign (R-Nevada). He also earned a Master of Science in Management from the W.P. Carey School of Business at Arizona State University. He currently serves as an adjunct professor of Business Communications at Mesa Community College.",
        "phone": "480-644-3004",
        "email": "councilmember.glover@mesaaz.gov",
        "fax": "480-644-3004",
        "facebook": "CouncilmemberChrisGlover",
        "twitterName": "MesaDistrict4",
        "twitterWidget": "465941739635613696",
        "address": "P.O. Box 1466\nMesa, AZ 85211-1466",
        "assistant": "Andrew Calhoun",
        "assistantphone": "480-644-2190",
        "assistantemail": "andrew.calhoun@mesaaz.gov",
        "website": "http://www.mesaaz.gov/council/glover",
        "photo": "http://tomcfa.s3.amazonaws.com/district4.jpg"
    },
    {
        "name": "David Luna",
        "district": 5,
        "bio": "Appointed to fill the vacancy on the Mesa City Council in September of 2013, David Luna serves as the councilmember for District 5. Luna has worked as the Director of Education Television for Mesa Public Schools since 1988, directing and managing channel 99 and edtv99.org. He is also an adjunct faculty member at Mesa Community College, teaching communications. His term on the Mesa City Council runs until January of 2015.\nLuna represents Mesa nationally as a member of the National League of Cities' Information Technology and Steering Committee.",
        "phone": "480-644-3771",
        "email": "councilmember.luna@mesaaz.gov",
        "fax": "480-644-2175",
        "facebook": "CouncilmemberDavidLuna",
        "twitterName": "MesaDistrict5",
        "twitterWidget": "465941843922792448",
        "address": "P.O. Box 1466\nMesa, AZ 85211-1466",
        "assistant": "Charlotte McDermott",
        "assistantphone": "480-644-5294",
        "assistantemail": "District5@mesaaz.gov",
        "website": "http://www.mesaaz.gov/council/luna",
        "photo": "http://tomcfa.s3.amazonaws.com/district5.jpg"
    },
    {
        "name": "Scott Somers",
        "district": 6,
        "bio": "Councilmember Scott Somers was first elected to the Mesa City Council in 2006, and re-elected in 2010. He spent two years serving Mesa as Vice Mayor from 2011 to 2013. He works to accomplish his District's priorities: ensuring fiscal stability, improving public safety, and strategic planning to make the Mesa Gateway Area a high-wage job hub.\nCouncilmember Somers currently represents Mesa as the Chair of the Regional Public Transportation Authority and on the Board of Directors for the Chamber of Commerce and East Valley Partnership. ",
        "phone": "480-644-4003",
        "email": "councilmember.somers@mesaaz.gov",
        "fax": "480-644-2175",
        "facebook": "CouncilmemberScottSomers",
        "twitterName": "MesaDistrict6",
        "twitterWidget": "465941964072828928",
        "address": "P.O. Box 1466\nMesa, AZ 85211-1466",
        "assistant": "Matt Clark",
        "assistantphone": "480-644-4745",
        "assistantemail": "matthew.clark@mesaaz.gov",
        "website": "http://www.mesaaz.gov/council/somers",
        "photo": "http://tomcfa.s3.amazonaws.com/district6.jpg"

    },
    {
        "name": "Alex Finter",
        "district": 0,
        "bio": "Alex Finter became Mayor of Mesa, the 3rd largest city in Arizona and 38th largest in America, in April of 2014 following the resignation of Mayor Scott Smith. Elected to represent District 2 on the Mesa City Council in June of 2008 and re-elected uncontested to a second term in August of 2012, Alex Finter was named Vice Mayor of Mesa in January of 2013. In the private-sector, Finter is a businessman and partner at Worldwide Investments LLC. ",
        "phone": "480-644-2388",
        "email": "mayor@mesaaz.gov",
        "facebook": "https://www.facebook.com/MesaMayorsOffice",
        "twitterName": "https://twitter.com/MesaMayorOffice",
        "address": "Office of the Mayor\nP.O. Box 1466\nMesa, AZ 85211-1466",
        "assistant": "Misty Wells",
        "assistantphone": "480-644-2396",
        "assistantemail": "misty.wells@mesaaz.gov",
        "website": "http://www.mesaaz.gov/mayor/",
        "photo": "http://tomcfa.s3.amazonaws.com/district7.jpg"

    }
]

