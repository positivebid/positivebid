
PB = window.PB ||= {}

PB.Status = Backbone.Model.extend

  initialize: (args) ->
    #nothing yet

  check_and_bind: ->
    @socket_bindings()
    @check()

  check: ->
    if NoDevent.socket.socket.connected
      @set 'connected', true
      @set 'status', 'connected'

  socket_bindings: ->
    NoDevent.on "connect", =>
      @set('connected', true)
      @set('status', 'connected')
    NoDevent.on "disconnect", =>
      @set('connected', false)
      @set('status', 'disconnected')


PB.status = new PB.Status  # global status

