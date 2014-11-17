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
