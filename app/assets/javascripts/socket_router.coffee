
PB = window.PB ||= {}


window.global_room = NoDevent.room('global_room')
global_room.join (err) ->
  if err?
    console?.log "error joining global_room", err
  else
    console?.log "joined global_room"
  

socket_defaults(global_room)


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

global_room.on "auction_list", (data) ->
  console?.log("got auction_list", data)
  PB.auctions.reset(data.auctions)

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


window.message_popup = (text) ->
  window.message_popup_close() if window.popup_sv?
  window.popup_sv = sv = new Sview('popups_message', {message: text})
  $.mobile.activePage.append(sv.html)
  sv.html.popup({history: false})
  sv.html.popup('open')
  window.popup_timeout = setTimeout message_popup_close, 4000

window.message_popup_close = () ->
  if window.popup_sv?
    clearTimeout(window.popup_timeout)
    window.popup_sv.html?.popup().popup('close')
    window.popup_sv.destroy()
    window.popup_sv = null


global_room.on "message", message_popup

global_room.on "user_left", (data) ->
  console?.log("got user_left", data)

global_room.on "viewer_entered", (data) ->
  console?.log("got viewer_entered", data)

global_room.on "viewer_left", (data) ->
  console?.log("got viewer_left", data)

global_room.on "lot_list", (data) ->
  console?.log("got lot_list", data)
  PB.lots.reset(data.lots)


NoDevent.on "connect", ->
  console.log "socket connected.."
  message_popup("Socket Connected!")
  #$("#status").removeClass("offline").addClass("online").find("p").text "You are online and can bid."

NoDevent.on "disconnect", ->
  console.log "socket disconnected.."
  message_popup("Socket Disconnected! :-(")
  #$("#connected").removeClass("on").find("strong").text "Offline"
  #$("#status").removeClass("online").addClass("offline").find("p").text "You are offline. please wait..."


