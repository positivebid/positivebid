
PB = window.PB ||= {}

PB.User = Backbone.Model.extend
  urlRoot: 'user'
  noIoBind: false
  socket: window.global_room

  initialize: (args) ->
    @id = args.id
    @image_url = args.image_url
    @email = args.email
    @admin = args.admin
    @telephone_number = args.telephone_number
    @anonymous_bidding = args.anonymous_bidding
    @mobile_number = args.mobile_number
    @bid_confirmation = args.bid_confirmation
    @share_confirmation = args.share_confirmation
    @outbid_confirmation = args.outbid_confirmation

    _.bindAll(@, 'serverChange', 'serverDelete', 'modelCleanup')
    # if we are creating a new model to push to the server we don't want
    # to iobind as we only bind new models from the server. This is because
    # the server assigns the id.
    if (!this.noIoBind)
      this.ioBind('update', @serverChange, @)
      this.ioBind('delete', @serverDelete, @)

  viewUrl: -> "#/users/#{@id}"

  name: -> "#{@get('first_name')} #{@get('last_name')}"


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

