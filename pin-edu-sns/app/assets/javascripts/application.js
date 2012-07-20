// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require ./util/pie
//= require ./util/jquery.pie.is_in_screen
//= require ./util/jquery.pie.domdata
//= require ./util/jquery.pie.path_join
//= require ./util/pie.image_in_box
//= require ./util/form
//= require ./tip_messages/notifier
//= require_tree .

// show
jQuery(function(){
  jQuery('form a.form-submit-button').click(function(){
    jQuery(this).closest('form').submit();
  })
});