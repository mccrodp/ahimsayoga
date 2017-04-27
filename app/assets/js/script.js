/* ========================================================================
 * Site Javascript
 *
 * ========================================================================
 * Copyright 2016 Bootbites.com (unless otherwise stated)
 * For license information see: http://bootbites.com/license
 * ======================================================================== */

// ==================================================
// Heading
// ==================================================
$(document).ready(function() {

  // Smooth scrolling
  // ------------------------

  $(function() {
  $('a[href*="#"]:not([href="#"])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html, body').animate({
          scrollTop: target.offset().top
        }, 1000);
        return false;
      }
    }
  });
  });

  // Counting numbers
  // ------------------------

  // $('[data-toggle="counter-up"]').counterUp({
  //   delay: 10,
  //   time: 1000
  // });

  // Tooltip & popovers
  // ------------------------
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();

  // Background image via data tag
  // ------------------------
  $('[data-block-bg-img]').each(function() {
    // @todo - invoke backstretch plugin if multiple images
    var $this = $(this),
      bgImg = $this.data('block-bg-img');

      $this.css('backgroundImage','url('+ bgImg + ')').addClass('block-bg-img');
  });

  // jQuery counterUp
  // ------------------------
  // if(jQuery().counterUp) {
  //   $('[data-counter-up]').counterUp({
  //     delay: 20,
  //   });
  // }

  //Scroll Top link
  // ------------------------
  $(window).scroll(function(){
    if ($(this).scrollTop() > 100) {
      $('.scrolltop').fadeIn();
    } else {
      $('.scrolltop').fadeOut();
    }
  });

  $('.scrolltop, .navbar-brand').click(function(){
    $("html, body").animate({
      scrollTop: 0
    }, 600);
    return false;
  });

});
