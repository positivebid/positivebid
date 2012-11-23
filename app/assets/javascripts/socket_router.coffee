
PB = window.PB ||= {}


window.global_room = NoDevent.room('global_room')


global_room.on "join", (err) ->
  if err?
    console?.log "just got error joining global_room", err
  else
    console?.log "just joined global_room"

global_room.on "leave", (err) ->
  if err?
    console?.log "just got error leaving global_room", err
  else
    console?.log "just left global_room"


# joining room here..
global_room.join()



window.message_popup = (title, text, delay = 4000) ->
  window.message_popup_close() if window.popup_sv?
  window.popup_sv = sv = new Sview('popups_message', {title: title, message: text})
  $.mobile.activePage.append(sv.html)
  $.mobile.activePage.page()
  sv.html.popup({history: false})
  sv.html.popup('open')
  window.popup_timeout = setTimeout message_popup_close, delay

window.simple_message_popup = (text) -> message_popup('Message', text)

window.message_popup_close = () ->
  if window.popup_sv?
    clearTimeout(window.popup_timeout)
    window.popup_sv.html?.popup().popup('close')
    window.popup_sv.destroy()
    window.popup_sv = null


global_room.on "message", simple_message_popup

global_room.on "user_left", (data) ->
  console?.log("got user_left", data)

global_room.on "viewer_entered", (data) ->
  console?.log("got viewer_entered", data)

global_room.on "viewer_left", (data) ->
  console?.log("got viewer_left", data)

global_room.on "lot_list", (data) ->
  console?.log("got lot_list", data)
  PB.lots.reset(data.lots)

global_room.on "auction_list", (data) ->
  console?.log("got auction_list", data)
  PB.auctions.reset(data.auctions)

NoDevent.on "connecting", (transport_type) ->
  console?.log "socket connecting.."

NoDevent.on "connect", ->
  console?.log "socket connected.."

NoDevent.on "disconnect", ->
  console?.log "socket disconnected.."

NoDevent.on "reconnect", ->
  window.updateR ->
    message_popup("Data Refreshed", "nice!", 2000)
  , ->
    message_popup("Data Problem", "Data could not be refreshed :-(", 5000)

#  wait for domready for messge_popups
jQuery ->

  global_room.on "user_entered", (data) ->
    #TODO add to model/collection
    # bind UI to model/collection events
    console?.log("got user_entered", data)
    sv = new Sview('popups_user_entered', {user: data})
    $.mobile.activePage.append(sv.html)
    sv.html.popup({history: false})
    sv.html.popup('open')
    setTimeout ->
      sv.html.popup('close')
      sv.html.remove()
      sv.destroy()
    , 4000

  NoDevent.on "connect", ->
    message_popup("Connection Status", "Connected!")

  NoDevent.on "disconnect", ->
    message_popup("Connection Status", "Disconnected! :-(")

  NoDevent.on "reconnect", ->
    console?.log "socket reconnected.."
    message_popup("Connection Status", "Reconnected! ")

  NoDevent.on "reconnecting", (delay, attempts) ->
    console?.log "socket reconnecting.."
    message_popup("Connection Status", "Reconnecting... (attempt ##{attempts})")

  NoDevent.on "error", ->
    console?.log "socket error.."
    message_popup("Connection Status", "Socket Error :-(")

  NoDevent.on "connecting", (transport_type) ->
    message_popup("Connection Status", "Connecting... (via #{transport_type})")

  NoDevent.on "close", (transport_type) ->
    console?.log "socket closed..."
    message_popup "Connection Status", "Socket Closed. :-("

  NoDevent.on "reconnect_failed", (transport_type) ->
    console?.log "socket reconnect failed..."
    message_popup("Connection Status", "Reconnect Failed :-(")

