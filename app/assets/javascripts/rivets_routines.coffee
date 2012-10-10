
window.rivets.routines.href = (el, value) ->
  el.href = value

window.rivets.routines.src = (el, value) ->
  el.src = value

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
  return moment(value)?.fromNow()

window.rivets.formatters.pound = (value) ->
  return "£#{value}"
