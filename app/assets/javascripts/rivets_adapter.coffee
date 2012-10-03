

window.rivets.config.adapter =

  subscribe: (obj, keypath, callback) ->
    if (obj instanceof Backbone.Collection) and (keypath is 'models')
      obj.on("add remove reset",  -> callback(obj.models))
    else
      obj.on("change:" + keypath, (m, v) ->  callback(v) )

  unsubscribe: (obj, keypath, callback) ->
    obj.off('change:' + keypath, callback)
  
  read: (obj, keypath) ->
    return obj.get(keypath)
  
  publish: (obj, keypath, value) ->
    obj.set(keypath, value)


