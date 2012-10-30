pie.load ->
  $location = jQuery(".page-admin-model-show .teacher .location")
  if $location.exists()
    $location.find(".show .edit-btn").on "click", (evt) ->
      $target = jQuery(evt.target)
      $current_location = $target.closest(".location")
      content = $current_location.find(".show .content").get(0).innerHTML
      $current_location.find(".show").hide()
      $current_location.find(".edit input").attr("value", content)
      $current_location.find(".edit").show()

    $location.find(".edit .cancel-btn").on "click", (evt) ->
      $target = jQuery(evt.target)
      $current_location = $target.closest(".location")
      $current_location.find(".edit input").attr("value", "")
      $current_location.find(".show").show()
      $current_location.find(".edit").hide()

    $location.find(".edit .update-btn").on "click", (evt) ->
      $target = jQuery(evt.target)
      $current_location = $target.closest(".location")
      
      content = $current_location.find(".edit input").attr("value")
      return if "" == content

      url = $target.data("url")
      jQuery.ajax
        url: url
        type: 'PUT'
        data:
          location: content
        success: (res)->
          $current_location.find(".edit input").attr("value", "")
          $current_location.find(".show .content").get(0).innerHTML = content
          $current_location.find(".show").show()
          $current_location.find(".edit").hide()
      