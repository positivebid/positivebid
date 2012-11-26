
$ = jQuery

window.rivets.binders.href = (el, value) ->
  el.href = value

window.rivets.binders.src = (el, value) ->
  el.src = value

window.rivets.binders.datetime = (el, value) ->
  el.setAttribute 'datetime', value

window.rivets.binders.sam = (el, value) ->
  el.setAttribute 'sam', value

window.rivets.binders.css_highlight = (el, value) ->
  $(el).css_highlight()

window.rivets.binders.a_enabled = (el, value) ->
  $el = $(el)
  if value
    $el.removeClass('ui-disabled')
  else
    $el.addClass('ui-disabled')

window.rivets.binders.submitdisabled = (el, value) ->
  $el = $(el)
  if value
    $el.closest('div.ui-btn').addClass('ui-disabled')
  else
    $el.closest('div.ui-btn').removeClass('ui-disabled')

window.rivets.binders.jqbtntext = (el, value) ->
  $el = $(el)
  if value
    $el.closest('div.ui-btn').find('span.ui-btn-text').text(value)

window.rivets.binders.jq_a_btn_icon = (el, value) ->
  $el = $(el)
  setTimeout ->
    if $el.attr('data-icon') and ($el.attr('data-icon') isnt "false")
      $holder = $el
    else
      $holder = $el.find('[data-icon]:first')
    current = $holder.attr('data-icon')
    $holder.attr('data-icon', value)
    $el.find('span.ui-icon').removeClass("ui-icon-#{current}").addClass("ui-icon-#{value}")
  , 0


window.rivets.binders.jq_a_btn_text = (el, value) ->
  $el = $(el)
  setTimeout ->
    $el.find('span.ui-btn-text').text value
  , 0

# dummy routine that runs jquerymobile listview('refresh') on the next tick
# after the dom has been updated with new raw markup
window.rivets.binders.listview_refresh = (el, value) ->
  $el = $(el)
  setTimeout ->
    $el.listview()
    $el.listview('refresh')
  , 0


##
## Formatters
##

window.rivets.formatters.nice_datetime = (value) ->
  return moment(value)?.calendar()

window.rivets.formatters.fromNow = (value) ->
  if mv = moment(value)
    if (mv > moment().subtract('s',20)) and (mv < moment())
      return "just now"
    else
      return moment(value)?.fromNow()
  else
    return "unknown time"

window.rivets.formatters.pound = (value) ->
  return "£#{value}"
