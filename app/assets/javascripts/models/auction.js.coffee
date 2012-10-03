
PB = window.PB ||= {}

PB.Auction = Backbone.Model.extend
  urlRoot: 'auction'
  noIoBind: false
  socket: window.socket

  initialize: (args = {}) ->
    @name = args.name
    @id = args.id
    @description = args.description
    @image_url = "/img/logo/positivebid_rounded_128.png"
    _.bindAll(@, 'serverChange', 'serverDelete', 'modelCleanup')

    # if we are creating a new model to push to the server we don't want
    # to iobind as we only bind new models from the server. This is because
    # the server assigns the id.
    if (!this.noIoBind)
      this.ioBind('update', @serverChange, @)
      this.ioBind('delete', @serverDelete, @)

  viewUrl: -> "#/auctions/#{@id}"
  newLotUrl: -> "#/auctions/#{@id}/lots/new"
  lotsUrl: -> "#/auctions/#{@id}/lots"

  sponsors: -> PB.sponsors.for_auction(@auction_id)


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





