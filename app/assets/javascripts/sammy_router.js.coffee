PB = window.PB ||= {}

window.app = PB.app = $.sammy(->
  
  reverse_back = false  # here for closure scope 

  useReverse = ->
    if window.reverse_back
      window.reverse_back = false
      true
    else
      false

  #see render: remove the last page.
  #see render:$('div').live 'pageshow', (event, ui) ->
  #see render:  ui.prevPage.remove()

  render = (sv) ->
    #window.sv = sv
    $v = sv.html
    PB.$body.append $v
    $v.page()  # jquery mobile enhance
    $oldv = $.mobile.activePage
    $.mobile.changePage $v, {changeHash: false}
    $oldv?.remove()
    #if  sv.cid != @oldsview?.cid
    @oldsview?.destroy()
    @oldsview = sv
    return false

  sammy_hack = (context) ->
    window.setTimeout (->
      location_proxy.unbind()
      context.app.setLocation "#/"
      context.app.last_location = "#/"
      location_proxy.bind()
    ), 55 # so that the same path can be called twice, eg '#/more'

  @element_selector = "body"
  location_proxy = new Sammy.DataLocationProxy(this, "location", "sam_click")
  @setLocationProxy location_proxy
  @use Sammy.NestedParams
  @hist = []
  reverse_back = false
  form_auction = null  # set scope

  
  @get "#/", (context) ->
    context.redirect("#/reload")

  # workaround for facebook redirect 
  @get "#_=_", (context) ->
    context.redirect("#/reload")

  @get "#/options", (context) ->
    render( new Sview('options', {}) )

  @get "#/login",  (context) ->
    render( new Sview('login', {}) )
  
  @get "#/auctions",  (context) ->
    render( new Sview('auctions_index', {auctions: PB.auctions, current_user: window.current_user, status: PB.status  }) )

  @post "#/auctions",  (context) ->
    new_auction = new PB.Auction(context.params.auction)
    new_auction.save()
    context.redirect("#/auctions")
    return false
  

  @get "#/auctions/:id", (context) ->
    #OLD window.socket.emit 'enter_auction', { id: context.params.id }
    render( new Sview('auctions_show', {auction: PB.auctions.get(context.params.id), status: PB.status }) )
    
  @get "#/auctions/:auction_id/lots", (context) ->
    auction = PB.auctions.get(context.params.auction_id)
    unless auction?
      console?.log 'auction not found for id:', context.params.auction_id
      context.redirect("#/")
      return false
    render( new Sview('lots_index', {auction: auction, lots: auction.lots, status: PB.status }) )
    return false

  @post "#/lots",  (context) ->
    new_lot = new PB.Lot(context.params.lot)
    new_lot.save()
    context.redirect("#/auctions/#{new_lot.auction_id}/lots")
    return false


  @get "#/lots/:id", (context) ->
    lot = PB.lots.get(context.params.id)
    unless lot?
      console?.log 'lot not found for id:', context.params.id
      context.redirect("#/")
      return false
    render( new Sview('lots_show', {lot: lot, auction: lot.auction(), bid: lot.next_bid(), items: lot.items, status: PB.status }) )

  @get "#/lots/:id/description", (context) ->
    lot = PB.lots.get(context.params.id)
    unless lot?
      console?.log 'lot not found for id:', context.params.id
      context.redirect("#/")
      return false
    render( new Sview('lot_description', {lot: lot, auction: lot.auction(), bid: lot.next_bid(), items: lot.items, status: PB.status }) )

  @get "#/lots/:id/pay", (context) ->
    lot = PB.lots.get(context.params.id)
    unless lot?
      console?.log 'lot not found for id:', context.params.id
      context.redirect("#/")
      return false
    render( new Sview('lot_pay', {lot: lot, auction: lot.auction(), bid: lot.next_bid(), items: lot.items, status: PB.status }) )

 

  @post "#/bids",  (context) ->
    #console?.log('context.params.bid', context.params.bid)
    #console?.log('context.params.bid.amount', context.params.bid.amount)
    new_bid = PB.bids.create(context.params.bid)
    #console?.log('new_bid', new_bid.get('amount'), new_bid)
    #context.redirect("#/lots/#{context.params.bid.lot_id}")
    return false

  @get "#/reload", (context) ->
    render( new Sview('reload', {}) )
    window.reverse_back = true
    setTimeout ->
      reloadR( ->
        context.redirect "#/auctions"
      , ->
        removeExistingModelData()
        delete R.current_user
        context.redirect "#/root"
        console?.log
          title: "Data Error"
          text: "logging you out!"
      )
      

    , 500  # need to wait for jquery mobile page to fully render
    false


)



