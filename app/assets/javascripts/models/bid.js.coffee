
PB = window.PB ||= {}

PB.Bid = Backbone.Model.extend
  noIoBind: false
  socket: window.global_room

  initialize: (args) ->
    @id = args.id
    @lot_id = args.lot_id
    @user_id = args.user_id
    @amount = args.amount
    @created_at = args.created_at

    _.bindAll(@, 'serverChange', 'serverDelete', 'modelCleanup')
    # if we are creating a new model to push to the server we don't want
    # to iobind as we only bind new models from the server. This is because
    # the server assigns the id.
    if (!this.noIoBind)
      this.ioBind('update', @serverChange, @)
      this.ioBind('delete', @serverDelete, @)

  viewUrl: -> "#/bids/#{@id}"

  lot: -> PB.lots.get(@get('lot_id'))
  user: -> PB.users.get(@get('user_id'))


  serverChange: (data) ->
    # Useful to prevent loops when dealing with client-side updates (ie: forms).
    data.fromServer = true
    @set(data)

  serverDelete: (data) ->
    if (@collection)
      @collection.remove(@)
    else
      @trigger('remove', @)
    @modelCleanup()

  modelCleanup: ->
    @ioUnbindAll()
    return @

