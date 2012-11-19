
PB = window.PB ||= {}

PB.User = Backbone.Model.extend
  urlRoot: 'user'
  noIoBind: false
  socket: window.global_room

  initialize: (args = {}) ->
    @id = args.id

    _.bindAll(@, 'serverChange', 'serverDelete', 'modelCleanup')
    # if we are creating a new model to push to the server we don't want
    # to iobind as we only bind new models from the server. This is because
    # the server assigns the id.
    if (!this.noIoBind)
      this.ioBind('update', @serverChange, @)
      this.ioBind('delete', @serverDelete, @)

  viewUrl: -> "#/users/#{@id}"

  name: -> "#{@get('first_name')} #{@get('last_name')}"

  imageUrl: ->
    url = @get('image_url')
    if (not url?) or (url is '')
      "/img/logo/positivebid_rounded_128.png"
    else
      url


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

