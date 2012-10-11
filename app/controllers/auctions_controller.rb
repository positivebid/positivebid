class AuctionsController < ApplicationController

  resources_controller_for :auctions

  def new_resource(attributes)
    super(attributes) do |r|
      Time.zone = r.time_zone if r.time_zone
    end
  end

end
