// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery_nested_form
//= require_tree .

$(document).ready(function() {
  // for buttons
  $('select').material_select();
  // for home page
  $(".button-collapse").sideNav();
  $('.parallax').parallax();
  $('.dropdown-button').dropdown({
    inDuration: 300,
    outDuration: 225,
    constrain_width: true, // Does not change width of dropdown to that of the activator
    hover: false, // Activate on hover
    gutter: 0, // Spacing from edge
    belowOrigin: true // Displays dropdown below the button
  	}
	);
  // for items
  if ($('.tabs-wrapper').length !== 0) {
    $('.tabs-wrapper .row').pushpin({ top: $('.tabs-wrapper').offset().top });
  }
  $('.materialboxed').materialbox(); // shadow box for image
  $('.alert-box').fadeIn('normal', function() {
      $(this).delay(3700).fadeOut(400);
   });
});



