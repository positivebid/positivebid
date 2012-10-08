
PB = window.PB ||= {}

PB.Lot = Backbone.Model.extend
  urlRoot: 'lot'
  noIoBind: false
  socket: window.global_room

  initialize: (args) ->
    @id = args.id
    @auction_id = args.auction_id
    @current_bid_id = args.current_bid_id
    @name = args.name
    @description = args.description
    @increment = args.increment or 1
    @paid = args.paid
    @sold = args.sold
    @sold_for = args.sold_for
    @sale_start_at = args.sale_start_at
    @sale_end_at = args.sale_end_at

    if @id?
      @items = PB.LotItems.for_lot(@id)

    _.bindAll(@, 'serverChange', 'serverDelete', 'modelCleanup')
    # if we are creating a new model to push to the server we don't want
    # to iobind as we only bind new models from the server. This is because
    # the server assigns the id.
    if (!this.noIoBind)
      this.ioBind('update', @serverChange, @)
      this.ioBind('delete', @serverDelete, @)

  auction: -> PB.auctions.get(@auction_id)
  current_bid: -> PB.bids.get(@get('current_bid_id'))  # use get!
  bids: -> PB.bids.for_lot(@auction_id)

  # view helpers
  viewUrl: -> "#/lots/#{@id}"
  newItemUrl: -> "#/lots/#{@id}/items/new"
  imageUrl: -> @get('image_url') or "/img/logo/positivebid_rounded_128.png"
  current_bid_user_name: -> @current_bid()?.user()?.name()
  current_bid_user_image_url: -> @current_bid()?.user()?.image_url
  current_bid_amount: -> @current_bid()?.amount or 0
  current_bid_created_at: -> @current_bid()?.created_at
  next_bid_amount: -> parseInt(@current_bid_amount(),10) + parseInt(@increment,10)

  createOrUpdate: -> if not @id? then 'Create' else 'Update'

  errors_base: -> ''  #todo
  errors_name: -> ''  #todo
  errors_description: -> ''  #todo


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

