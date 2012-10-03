
PB = window.PB ||= {}

PB.Items = Backbone.Collection.extend
  model: PB.Item
  url: 'items'
  socket: window.socket
  initialize: () ->
    _.bindAll(@, 'serverCreate', 'collectionCleanup')
    @ioBind('create', window.socket, @serverCreate, @)

  serverCreate: (data) ->
    console?.log('creating new item with', data)
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

      

PB.items = new PB.Items() # global list of lots

# model events also get re-triggered on the collection
PB.items.on 'all',  (event, model, collection) ->
  console?.log "Model '#{model?.cid}' triggered '#{event}'. Collection length is #{collection?.length}"

