
PB = window.PB ||= {}

# set the unique 'connection' cookie  used to identify re-connects
unless $.cookie('nuid')?
  $.cookie('nuid', window.nuid() , { path: '/' })

#window.socket ?= io.connect()
window.socket ?= NoDevent

socket_defaults(socket)

socket.on "auction_list", (data) ->
  console?.log("got auction_list", data)
  PB.auctions.reset(data.auctions)

socket.on "user_entered", (data) ->
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


socket.on "user_left", (data) ->
  console?.log("got user_left", data)

socket.on "viewer_entered", (data) ->
  console?.log("got viewer_entered", data)

socket.on "viewer_left", (data) ->
  console?.log("got viewer_left", data)

socket.on "lot_list", (data) ->
  console?.log("got lot_list", data)
  PB.lots.reset(data.lots)


socket.on "connect", ->
  socket.emit('list_auctions')

  $("#status").removeClass("offline").addClass("online").find("p").text "You are online and can bid."

socket.on "disconnect", ->
  $("#connected").removeClass("on").find("strong").text "Offline"
  $("#status").removeClass("online").addClass("offline").find("p").text "You are offline. please wait..."


