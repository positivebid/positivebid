
#$window = $(window)
#window.window_width = ->  $window.width()

window.supports_html5_storage = ->
  try
    if window["localStorage"]?
      return window["localStorage"]
  catch e
    console?.log("no local storage: #{e}")
    return false

window.localStorage_getItem = (key) ->
  localStorage.getItem(key)


window.localStorage_setItem = (key, value) ->
  try
    localStorage.setItem(key, value)
  catch err
    if (err.name).toUpperCase() == 'QUOTA_EXCEEDED_ERR'
      alert "You must have local storage enabled (or private browsing turned off)"
       


window.R ?= {}

window.loadR = (R = {}) ->
  PB.auctions.reset(R.auctions) if R.auctions?
  PB.lots.reset(R.lots) if R.lots?
  PB.items.reset(R.items) if R.items?
  PB.users.reset(R.users) if R.users?
  PB.bids.reset(R.bids) if R.bids?
  if R.current_user?
    window.current_user = new PB.User(R.current_user)

    # TODO relocate some where better
    
    setTimeout ->
      room = NoDevent.room("User_#{current_user.id}")
      room.join()
      room.on('message', simple_message_popup)
    , 0
  else
    window.current_user = null

#window.removeExistingModelData = ->
# window.current_user = null
#  for m in [ PB.auctions, PB.lots, PB.items, PB.bids, PB.users ]
#    m.reset()


window.reloadR = (callback, error_callback = null) ->
  json_url = "#{R.app_host}/app.json"
  $.ajax
    dataType: "json"
    type: "GET"
    url: json_url
    success: (data) ->
      R = data
      loadR R
      callback.call()  if callback

    error: (data) ->
      console?.log "reload R error", data
      error_callback.call()  if callback

window.mergeR = (R = {}) ->
  PB.auctions.update(R.auctions) if R.auctions?
  PB.lots.update(R.lots) if R.lots?
  PB.items.update(R.items) if R.items?
  PB.users.update(R.users) if R.users?
  PB.bids.update(R.bids) if R.bids?
  if R.current_user?
    if window.current_user?
      window.current_user.set(R.current_user)
    else
      window.current_user = new PB.User(R.current_user)

      # TODO relocate some where better
      
      setTimeout ->
        room = NoDevent.room("User_#{current_user.id}")
        room.join()
        room.on('message', simple_message_popup)
      , 0
  else
    window.current_user = null

window.updateR = (callback, error_callback = null) ->
  json_url = "#{R.app_host}/app.json"
  $.ajax
    dataType: "json"
    type: "GET"
    url: json_url
    success: (data) ->
      R = data
      mergeR R
      callback.call()  if callback

    error: (data) ->
      console?.log "update R error", data
      error_callback.call()  if callback

window.D2 = (val) -> (if (val < 10) then "0" + val else val)


#window.phonegap = -> PhoneGap?
#window.phonegap_target = -> if PhoneGap? then "_blank" else "_top"

#window.progressHandlingFunction = (e) ->
# if e.lengthComputable
#   $('progress').attr({value:e.loaded,max:e.total})


window.nice_date = (string) ->
  if string? and string != ""
    moment(string).format("ddd, Do MMM YYYY")
  else
    ""
window.nice_datetime = (string) ->
  if string? and string != ""
    moment(string).format("ddd, Do MMM YYYY h:mm A")
  else
    ""

window.nice_time = (mins) ->
  h = (parseInt(mins/60,10))%12
  h = 12 if h == 0
  "#{h}:#{D2(mins%60)} #{if mins < 720 then 'AM' else 'PM'}"

$.fn.css_highlight = ->
  @removeClass('transition').addClass('change')
  @position()
  @addClass('transition').removeClass('change')


window.csrf_token = -> $("meta[name=csrf-token]").attr("content")
window.csrf_param = -> $("meta[name=csrf-param]").attr("content")

