class LotsController < ApplicationController

  resources_controller_for :lots

  append_before_filter :set_time_zone


  private 

  def set_time_zone
    Time.zone = enclosing_resource.time_zone if enclosing_resource.try(:time_zone)
  end

  def clean_params
    # on this controller filter out state_event params that dont 
    # being with "organiser_"...
    if params[:lot] and params[:lot][:state_event] and not params[:lot][:state_event].match(/\Aorganiser_/)
      Rails.logger.warn("Removing bogus state_event: #{params[:lot][:state_event]} ")
      delete params[:lot][:state_event]
    end
  end


end
