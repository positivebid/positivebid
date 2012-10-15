class PostsController < ApplicationController

  before_filter :require_admin
  resources_controller_for :posts


  def preview
    @post = resource_service.new(params[:post])
  end

end
