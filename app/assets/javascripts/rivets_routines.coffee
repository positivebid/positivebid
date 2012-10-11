
$ = jQuery

window.rivets.routines.href = (el, value) ->
  el.href = value

window.rivets.routines.src = (el, value) ->
  el.src = value

window.rivets.routines.datetime = (el, value) ->
  el.setAttribute 'datetime', value

window.rivets.routines.submitdisabled = (el, value) ->
  $el = $(el)
  if value
    $el.closest('div.ui-btn').addClass('ui-disabled')
  else
    $el.closest('div.ui-btn').removeClass('ui-disabled')

# dummy routine that runs jquerymobile listview('refresh') on the next tick
# after the dom has been updated with new raw markup
window.rivets.routines.listview_refresh = (el, value) ->
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
