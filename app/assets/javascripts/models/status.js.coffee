
PB = window.PB ||= {}

PB.Status = Backbone.Model.extend

  initialize: (args) ->
    @set('connected', false)
    @set('status', 'disconnected')

  check_and_bind: ->
    @socket_bindings()
    @check()
    return true

  check: ->
    if NoDevent.socket.socket.connected
      @set 'connected', true
      @set 'status', 'connected'

  message: ->
   if @get('status') == 'connected'
     "Your connection is good and you can watch and bid"
    else
      "<p>You are offline. You need to be online to see live auction updates and to bid.<p/><p>Please try <br/> 1. Reloading this page<br/> 2. Check your wifi/intenet connection.<br/>3. Using a different browser such as Opera, Firefox, or Chrome.</p>"

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

# global status
PB.status = new PB.Status()
