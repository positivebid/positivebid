
PB = window.PB ||= {}

PB.Sponsor = Backbone.Model.extend
  urlRoot: 'sponsor'
  noIoBind: false
  socket: window.socket

  initialize: (args) ->
    @id = args.id
    @auction_id = args.auction_id
    @name = args.name
    @description = args.description
    @logo_url = args.logo_url
    @website_url = args.website_url

    _.bindAll(@, 'serverChange', 'serverDelete', 'modelCleanup')
    # if we are creating a new model to push to the server we don't want
    # to iobind as we only bind new models from the server. This is because
    # the server assigns the id.
    if (!this.noIoBind)
      this.ioBind('update', @serverChange, @)
      this.ioBind('delete', @serverDelete, @)


  viewUrl: -> "#/sponsor/#{@id}"

  auction: -> PB.auctions.get(@auction_id)

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

