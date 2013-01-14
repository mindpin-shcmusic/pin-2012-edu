pie.load ->
  total_fixed_height = 40

  jQuery('.page-top-fixed').each ->
    $elm = jQuery(this)

    pos = $elm.position()
    left = pos.left

    $elm.css
      'position': 'fixed'
      'top': total_fixed_height
      'left': left
      'right': 0
      'z-index': 8

    total_fixed_height += $elm.outerHeight(true)

  jQuery('.page-content').css('margin-top', total_fixed_height)