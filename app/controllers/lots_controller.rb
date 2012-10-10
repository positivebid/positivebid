class LotsController < ApplicationController

  resources_controller_for :lots


  private 

  def clean_params
    # on this controller filter out state_event params that dont 
    # being with "organiser_"...
    if params[:lot] and params[:lot][:state_event] and not params[:lot][:state_event].match(/\Aorganiser_/)
      Rails.logger.warn("Removing bogus state_event: #{params[:lot][:state_event]} ")
      delete params[:lot][:state_event]
    end
  end


end
