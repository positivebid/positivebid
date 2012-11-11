class ItemsController < ApplicationController

  resources_controller_for :items

  def order
    order = params[:item]
    resource_service.order_by_ids(order)
  end

end
