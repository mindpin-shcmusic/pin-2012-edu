jQuery('a.comment-reply').click(function(e) {
  e.preventDefault();
  e.stopPropagation();

  var creator_id = jQuery(this).parent().data('creator_id');
  var comment_id = jQuery(this).parent().data('comment_id');

  jQuery('#comment_reply_comment_id').attr('value', comment_id);
  jQuery('#comment_reply_comment_user_id').attr('value', creator_id);

  jQuery('#comment_content').focus();
});
