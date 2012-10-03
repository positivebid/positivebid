
PB = window.PB ||= {}

PB.Bids = Backbone.Collection.extend
  model: PB.Bid
  url: 'bids'
  socket: window.global_room
  initialize: () ->
    _.bindAll(@, 'serverCreate', 'collectionCleanup')
    @ioBind('create', window.global_room, @serverCreate, @)

  serverCreate: (data) ->
    # make sure no duplicates, just in case
    exists = @get(data.id)
    if not exists?
      console?.log('creating bid with', data)
      @add(data)
    else
      console?.log('updating bid with', data)
      data.fromServer = true
      exists.set(data)

  collectionCleanup: (callback) ->
    @ioUnbindAll()
    @each (model) ->
      model.modelCleanup()
    return @

  for_lot: (lot_id) ->
    @filter (model) ->
      model.lot_id == lot_id
      

PB.bids = new PB.Bids() # global list of lots

# model events also get re-triggered on the collection
PB.bids.on 'all',  (event, model, collection) ->
  console?.log "Model '#{model?.cid}' triggered '#{event}'. Collection length is #{collection?.length}"

