
PB = window.PB ||= {}

PB.LotItems = class

  @lots = []

  @for_lot = (lot_id) ->
    return @lots[lot_id]  if @lots[lot_id]?
    litems = new Backbone.Collection
    litems.comparator = (ab) -> ab.get('position')
    @lots[lot_id] = litems
    return litems

