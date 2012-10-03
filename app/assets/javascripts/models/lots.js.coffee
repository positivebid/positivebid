
PB = window.PB ||= {}

PB.Lots = Backbone.Collection.extend
  model: PB.Lot
  url: 'lots'
  socket: window.global_room
  initialize: () ->
    _.bindAll(@, 'serverCreate', 'collectionCleanup')
    @ioBind('create', window.global_room, @serverCreate, @)

  serverCreate: (data) ->
    # make sure no duplicates, just in case
    exists = @get(data.id)
    if not exists?
      console?.log('creating lot with', data)
      @add(data)
    else
      console?.log('updating lot with', data)
      data.fromServer = true
      exists.set(data)

  collectionCleanup: (callback) ->
    @ioUnbindAll()
    @each (model) ->
      model.modelCleanup()
    return @

  for_auction: (auction_id) ->
    @filter (model) ->
      model.auction_id == auction_id

PB.lots = new PB.Lots() # global list of lots


# model events also get re-triggered on the collection
PB.lots.on 'all',  (event, model, collection) ->
  console?.log "Model '#{model?.cid}' triggered '#{event}'. Collection length is #{collection?.length}"

