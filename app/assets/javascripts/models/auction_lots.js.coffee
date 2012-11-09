
PB = window.PB ||= {}

PB.AuctionLots = class

  @auctions = []

  @for_auction = (auction_id) ->
    @auctions[auction_id] ?= new Backbone.Collection
      

