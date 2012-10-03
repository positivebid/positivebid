
PB = window.PB ||= {}

PB.Auctions = Backbone.Collection.extend
  model: PB.Auction
  url: 'auctions'
  socket: window.socket
  initialize: () ->
    _.bindAll(@, 'serverCreate', 'collectionCleanup')
    @ioBind('create', window.socket, @serverCreate, @)

  serverCreate: (data) ->
    console?.log('creating new auction with', data)
    # make sure no duplicates, just in case
    exists = @get(data.id)
    if not exists?
      @add(data)
    else
      data.fromServer = true
      exists.set(data)

  collectionCleanup: (callback) ->
    @ioUnbindAll()
    @each (model) ->
      model.modelCleanup()
    return @


PB.auctions = new PB.Auctions() # global list of all Auctions

# model events also get re-triggered on the collection
PB.auctions.on 'all',  (event, model, collection) ->
  console?.log "Model '#{model?.cid}' triggered '#{event}'. Collection length is #{collection?.length}"

