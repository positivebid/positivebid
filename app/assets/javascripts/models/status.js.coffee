
PB = window.PB ||= {}

PB.Status = Backbone.Model.extend

  initialize: (args) ->
    @set('connected', false)
    @set('status', 'disconnected')

  check_and_bind: ->
    @socket_bindings()
    @check()
    # check again in 1.2 seconds for Firefox
    setTimeout =>
      @check()
    , 1200

  check: ->
    if NoDevent.socket.socket.connected
      @set 'connected', true
      @set 'status', 'connected'

  socket_bindings: ->
    NoDevent.on "connect", =>
      @set('connected', true)
      @set('status', 'connected')
    NoDevent.on "reconnect", =>
      @set('connected', true)
      @set('status', 'connected')
    NoDevent.on "disconnect", =>
      @set('connected', false)
      @set('status', 'disconnected')

   icon: ->
     switch @get('connected')
       when true then "check"
       else "alert"
       
   text: ->
     switch @get('status')
       when "connected" then "Online"
       when "disconnected" then "Offline"
       else "unknown"

PB.status = new PB.Status  # global status
