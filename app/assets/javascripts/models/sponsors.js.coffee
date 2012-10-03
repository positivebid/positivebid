
PB = window.PB ||= {}

PB.Sponsors = Backbone.Collection.extend
  model: PB.Sponsor
  url: 'sponsors'
  socket: window.socket
  initialize: () ->
    _.bindAll(@, 'serverCreate', 'collectionCleanup')
    @ioBind('create', window.socket, @serverCreate, @)

  serverCreate: (data) ->
    console?.log('creating new lot with', data)
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

  for_auction: (auction_id) ->
    @filter (model) ->
      model.auction_id == auction_id

PB.sponsors = new PB.Sponsors() # global list of sponsors


# model events also get re-triggered on the collection
PB.sponsors.on 'all',  (event, model, collection) ->
  console?.log "Model '#{model?.cid}' triggered '#{event}'. Collection length is #{collection?.length}"

