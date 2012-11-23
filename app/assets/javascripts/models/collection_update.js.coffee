
# from http://stackoverflow.com/questions/7097498/updating-a-backbone-js-collection-without-wiping-old-models

Backbone.Collection::update = (colIn) ->

  ids = []

  _(colIn).each (modIn) ->
    existing = @get(modIn)
    # update existing models
    if (existing)
      existing.set(modIn)
    # add the new ones
    else
      @add(modIn)

    ids.push(modIn.id)
  , @

  # remove missing models (optional)
  toRemove = @reject (model) ->
    return _(ids).include(model.id)

  @remove(toRemove)
  return @

