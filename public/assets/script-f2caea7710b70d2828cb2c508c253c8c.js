jQuery( document ).ready(function() {
    "use strict";
    $("#status").css('display', 'block');
    $("#preloader").css('display', 'block');
    

    $(window).load(function() {
        $('.oi_page_holder').css('visibility', 'visible');
        // will first fade out the loading animation
        $("#status").fadeOut("slow");
        // will fade out the whole DIV that covers the website.
        $("#preloader").fadeOut("slow");
    });  
});
