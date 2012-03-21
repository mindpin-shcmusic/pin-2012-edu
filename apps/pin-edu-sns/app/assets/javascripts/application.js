// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

// 一些表单的基本事件绑定

jQuery(document).ready(function(){
  jQuery('form a.form-submit-button').click(function(){
    var elm = jQuery(this);
    if(elm.hasClass('disabled')) return;
    
    jQuery(this).closest('form').submit();
  })
});
