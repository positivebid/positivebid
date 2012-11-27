
PB = window.PB ||= {}

PB.Users = Backbone.Collection.extend
  model: PB.User
  url: 'users'
  socket: window.global_room
  initialize: () ->
    _.bindAll(@, 'serverCreate', 'collectionCleanup')
    @ioBind('create', window.global_room, @serverCreate, @)

  serverCreate: (data) ->
    # make sure no duplicates, just in case
    exists = @get(data.id)
    if not exists?
      console?.log('creating new user with', data)
      @add(data)
    else
      console?.log("updating user #{exists.id} with", data)
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
      

PB.users = new PB.Users() # global list of lots

# model events also get re-triggered on the collection
PB.users.on 'all',  (event, model, collection) ->
  console?.log "Model '#{model?.cid}' triggered '#{event}'. Collection length is #{collection?.length}"

