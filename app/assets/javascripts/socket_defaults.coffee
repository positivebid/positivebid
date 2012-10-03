
window.socket_defaults = (socket) ->

  if console?
    socket.on 'connect', ->
      console.log "socket:connect"

    socket.on 'connecting', ->
      console.log "socket:connecting"

    socket.on 'disconnect', ->
      console.log "socket:disconnect"
    
    socket.on 'connect_failed', ->
      console.log "socket:connect_failed"
    
    socket.on 'error', ->
      console.log "socket:error"

    socket.on 'message', (message, callback) ->
      console.log "socket:message", message, callback

    socket.on 'reconnect_failed', ->
      console.log "socket:reconnect_failed"

    socket.on 'reconnect', ->
      console.log "socket:reconnect"

    socket.on 'reconnecting', ->
      console.log "socket:reconnecting"


