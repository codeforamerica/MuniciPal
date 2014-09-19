// http://pixabay.com/en/blog/posts/how-to-use-pure-dropdown-menus-with-jquery-instead-56/
// These guys saved the day since Pure depends on the now defunct YUI for dropdowns.
$(document).ready(function(){
    var pure_menu;
    if ('ontouchstart' in window) {
        $('.pure-dropdown>a').click(function(e) {
            pure_menu = $(this).parent();
            var sub = pure_menu.toggleClass('pure-menu-open').find('.pure-menu-children').css('top', pure_menu.height());
            if (pure_menu.offset().left + sub.outerWidth() > $(window).width() && $(window).width() > sub.outerWidth())
                sub.css('left', pure_menu.width() - sub.outerWidth());
            else
                sub.css('left', 0);
            return false;
        });
     
        $(document).mousedown(function(e) {
            if (pure_menu &&!pure_menu.is(e.target) &&!pure_menu.has(e.target).length) {
                $('.pure-dropdown').removeClass('pure-menu-open');
                pure_menu = false;
            }
        });
     
    } else {
        $('.pure-dropdown>a').mouseenter(function(e) {
            pure_menu = $(this).parent();
            var sub = pure_menu.toggleClass('pure-menu-open').find('.pure-menu-children').css('top', pure_menu.height());
            if (pure_menu.offset().left + sub.outerWidth() > $(window).width() && $(window).width() > sub.outerWidth())
                sub.css('left', pure_menu.width() - sub.outerWidth());
            else
                sub.css('left', 0);
            return false;
        });
        $('.pure-dropdown').mouseleave(function() {
            $(this).removeClass('pure-menu-open');
            pure_menu = false;
        });
    }
});
