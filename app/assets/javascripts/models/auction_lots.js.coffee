
PB = window.PB ||= {}

PB.AuctionLots = class

  @auctions = []

  @for_auction = (auction_id) ->
    return @auctions[auction_id]  if @auctions[auction_id]?
    alots = new Backbone.Collection
    alots.comparator = (ab) -> ab.get('position')
    @auctions[auction_id] = alots
    return alots
      

