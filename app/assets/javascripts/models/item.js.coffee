
PB = window.PB ||= {}

PB.Item = Backbone.Model.extend
  urlRoot: 'item'
  noIoBind: false
  socket: window.global_room

  initialize: (args) ->
    @id = args.id
    @lot_id = args.lot_id
    @name = args.name
    @description = args.description
    @terms = args.terms
    @collection_details = args.collection_details
    @image_url = args.image_url or "/img/logo/positivebid_rounded_128.png"
    @donor_name = args.donor_name
    @donor_logo_url = args.donor_logo_url
    @donor_website_url = args.donor_website_url

    # if we have an id add to the LotItems collection
    if @id? and @lot_id?
      PB.LotItems.for_lot(@lot_id).add @

    _.bindAll(@, 'serverChange', 'serverDelete', 'modelCleanup')
    # if we are creating a new model to push to the server we don't want
    # to iobind as we only bind new models from the server. This is because
    # the server assigns the id.
    if (!this.noIoBind)
      this.ioBind('update', @serverChange, @)
      this.ioBind('delete', @serverDelete, @)

  viewUrl: -> "#/items/#{@id}"
  imageUrl: ->
    if id = @get('picture_id')
      "/pictures/#{id}/p80.jpg"
    else
      "/img/logo/positivebid_rounded_128.png"

  imageUrl320: ->
    if id = @get('picture_id')
      "/pictures/#{id}/p320.jpg"
    else
      "/img/logo/positivebid_rounded_128.png"

  lot: -> PB.lots.get(@lot_id)

  createOrUpdate: -> if not @id? then 'Create' else 'Update'

  errors_base: -> ''  #todo
  errors_name: -> ''  #todo
  errors_image_url: -> ''  #todo
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

