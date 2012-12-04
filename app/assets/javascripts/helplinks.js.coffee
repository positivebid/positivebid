
set_and_display = (data, $pop, key) ->
    title = data?.title || 'Information'
    content = data?.content || 'No information found.'
    if window.helplinks_edit_links
      if data?.title
        content = content + "<p><a target=\"_blank\" href=\"/helplinks/#{key}/edit\">edit</a></p>"
      else
        content = content + "<p><a target=\"_blank\" href=\"#{encodeURI("/helplinks/new?helplink[key]=#{key}")}\">add</a></p>"
    $pop.popover
      html: true
      title: title
      content: content
      trigger: 'manual'
    $pop.data('helplinked', true)
    $pop.data('shown', true)
    $pop.popover 'show'


$(document).on 'click', 'a.btn-helplink',  (event) ->
  $pop = $(this)
  if $pop.data('helplinked')
    #$pop.popover('toggle') # bug in bootstrap.
    if $pop.data('shown')
      $pop.popover('hide')
      $pop.data('shown', false)
    else
      $pop.popover('show')
      $pop.data('shown', true)
  else
    key = $pop.attr('data-helplink')
    $icon = $pop.find('i')
    $icon.removeClass('icon-info-sign').addClass('icon-refesh disabled')
    jqxhr = $.get("/helplinks/#{key}.json")
    jqxhr.complete ->
      $icon.addClass('icon-info-sign').removeClass('icon-refesh disabled')
    jqxhr.success ( data ) ->
      set_and_display data, $pop, key
    

