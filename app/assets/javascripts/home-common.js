$(function() {
  var windowHeight = $(window).height();
  var heightSectionPresentation = $("#tops-presentations").height();

  $('#intro').height(windowHeight);
  $('.blur').height(windowHeight);
  $('.blur-presentation').height(heightSectionPresentation);

  var wow = new WOW();
  wow.init();

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

  wow.sync()
});