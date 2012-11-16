
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
    @paid = args.paid
    @sold = args.sold
    @sold_for = args.sold_for
    @sale_start_at = args.sale_start_at
    @sale_end_at = args.sale_end_at

    if @id?
      @items = PB.LotItems.for_lot(@id)

    # if we have an id add to the LotItems collection
    if @id? and @auction_id?
      PB.AuctionLots.for_auction(@auction_id).add @

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
  biddingUrl: -> "#/lots/#{@id}"
  descriptionUrl: -> "#/lots/#{@id}/description"
  payUrl: -> "#/lots/#{@id}/pay"
  imageUrl: ->
    if fl = @items.first()
      fl.imageUrl()
    else
      "/img/logo/positivebid_rounded_128.png"

  justgivingUrl: ->
    "http://www.justgiving.com/donation/direct/charity/#{@auction().get('justgiving_sdi_charity_id')}?amount=#{@current_bid().get('amount')}&reference=lot-#{@id}&frequency=single&exitUrl=http%3a%2f%2fwww.positivebid.com%2freturn?donationId=JUSTGIVING-DONATION-ID"

  current_bid_user_name: -> @current_bid()?.user()?.name()
  current_bid_user_image_url: -> @current_bid()?.user()?.image_url
  current_bid_amount: -> @current_bid()?.get('amount') or 0
  current_bid_created_at: -> @current_bid()?.created_at
  next_bid_amount: -> parseInt(@current_bid_amount(),10) + parseInt(@get('min_increment'),10)

  createOrUpdate: -> if not @id? then 'Create' else 'Update'

  is_draft: -> @get('state') is "draft"
  is_published: -> @get('state') is "published"
  is_draft_or_published: -> @is_draft() or @is_published()
  is_forsale: -> @get('state') is "forsale"
  is_closing: -> @get('state') is "closing"
  is_sold: -> @get('state') is "sold"
  is_bought: -> @get('state') is "bought"
  is_bought_or_sold: -> @is_bought() or @is_sold()
  is_paid: -> @get('state') is "paid"

  i_need_to_pay: -> @is_bought_or_sold() and current_user? and @current_bid()? and current_user.id == @current_bid().get('user_id')

  is_scheduled: -> @get('timing') is "scheduled"
  is_manual: -> @get('timing') is "manual"

  isBiddingDisabled: -> not ( @is_forsale() or @is_closing() )
  isBiddingOpen: -> @is_forsale() or @is_closing()
  isBiddingPreSale: -> @is_draft() or @is_published()
  isBiddingPostSale: -> @is_bought() or @is_sold() or @is_paid()

  icon: ->
    return "gavel-closing" if @is_closing()
    return "gavel-halfway" if @is_forsale()
    return "gavel-down" if @isBiddingPostSale()
    return "gavel-up"

  errors_base: -> ''  #todo
  errors_name: -> ''  #todo
  errors_description: -> ''  #todo

  next_bid: () ->
    @_next_bid_cache ?= new PB.Bid({lot_id: @id})

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

