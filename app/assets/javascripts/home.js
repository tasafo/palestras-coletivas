// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.flexslider
//= require wow

$(function(){

  var windowHeight = $(window).height();
  var heightSectionPresentation = $("#tops-presentations").height();

  $('#intro').height(windowHeight);
  $('.blur').height(windowHeight);
  $('.blur-presentation').height(heightSectionPresentation);

  new WOW().init();

  $(".talker").each(function(index, val) {
    var delay = "." + index + 1 + "s";
    console.log(delay)
    $(this).attr('data-wow-delay', delay);
  });

  $('.flexslider').flexslider({
    animation: "slide",
    directionNav: false,
    controlNav: true,
    touch: false,
    pauseOnHover: true
  });

})