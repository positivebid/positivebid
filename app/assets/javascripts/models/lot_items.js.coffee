
PB = window.PB ||= {}

PB.LotItems = class

  @lots = []

  @for_lot = (lot_id) ->
    @lots[lot_id] ?= new Backbone.Collection
      

