class PublishedFaqsController < ApplicationController

  # caching disalbed for page title etc.
  # caches_action :show, :layout => false

  skip_before_filter :require_user
  resources_controller_for :published_faqs, :class => Faq

  def index
    redirect_to resource_path(find_resources.first)
  end

  def keyed
    self.resource = resource_service.find_by_key!(params[:id])
    respond_to do |format|
      format.html { render 'show' }
    end
  end

end
