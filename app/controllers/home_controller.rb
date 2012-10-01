class HomeController < ApplicationController

  resources_controller_for :user, :segment => 'home', :singleton => true, :find => :current_user, :route => 'home'

  def show
    self.resource = find_resource

    respond_to do |format|
      format.json { 
        #set_r
        render :json => @r
      }
      format.html
    end
  end

  private

  def set_r 
    @r['current_user']   = current_user # == resource
  end
  
end
