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
