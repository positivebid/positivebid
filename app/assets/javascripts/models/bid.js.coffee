
PB = window.PB ||= {}

PB.Bid = Backbone.Model.extend
  noIoBind: false
  socket: window.global_room
  urlRoot: 'bids'

  initialize: (args) ->
    @id = args.id
    @lot_id = args.lot_id
    @user_id = args.user_id
    @created_at = args.created_at

    _.bindAll(@, 'serverChange', 'serverDelete', 'modelCleanup', 'set_min_amount')

    if (not @id?) and (not @get('amount')?)
      @set 'amount',  parseInt(@lot().current_bid_amount(),10) + parseInt(@lot().increment,10)
      @lot().on "change:current_bid_id", @set_min_amount

    # if we are creating a new model to push to the server we don't want
    # to iobind as we only bind new models from the server. This is because
    # the server assigns the id.
    if (!this.noIoBind)
      this.ioBind('update', @serverChange, @)
      this.ioBind('delete', @serverDelete, @)

  viewUrl: -> "#/bids/#{@id}"

  lot: -> PB.lots.get(@get('lot_id'))
  user: -> PB.users.get(@get('user_id'))

  bid_now: -> "Bid £#{@get('amount')} Now"

  set_min_amount: ->
    console.log('setting amount...')
    @set 'amount',  parseInt(@lot().current_bid_amount(),10) + parseInt(@lot().increment,10)


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

