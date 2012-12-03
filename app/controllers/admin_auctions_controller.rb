class AdminAuctionsController < ApplicationController

  before_filter :require_admin

  resources_controller_for :admin_auctions, :class => Auction, :source => :auctions

  def new_resource
    super.tap{|d| d.creator = current_user }
  end

  def find_resources
    # postgresql 'ilike' case insenstive
    results = resource_service
    if params[:search] && params[:search][:name].present?
      results = results.where(["name ilike ?", "%#{params[:search][:name]}%"])
    end
    if params[:search] && params[:search][:description].present?
      results = results.where(["description ilike ?", "%#{params[:search][:description]}%" ] )
    end
    if params[:search] && params[:search][:state].present?
      results = results.where(:state => params[:search][:state] )
    end
    if params[:order]
      results = results.order(params[:order])
    elsif params[:search] && params[:search][:state] == "queued"
      results = results.order('begin_ticket_sale_at')
    else
      results = results.order('id DESC')
    end
    results.page( params[:page] )
  end

  def update
    self.resource = find_resource

    singularizer = defined?(ActiveModel::Naming.singular) ? ActiveModel::Naming.method(:singular) : ActionController::RecordIdentifier.method(:singular_class_name)
    resource_form_name = singularizer.call(resource_class)
    attributes = params[resource_form_name] || params[resource_name] || {}

    # manually set each attribute to avoid mass assignment protection
    attributes.each do |key, value|
      resource.send("#{key}=", value)
    end

    respond_to do |format|
      if resource.save
        format.html do
          flash[:notice] = "#{resource_name.humanize} was successfully updated."
          redirect_to resource_url
        end
        format.js
        format.json  { render :json => resource }
      else
        format.html   { render :action => "edit" }
        format.js     { render :action => "edit" }
        format.json   { render :json => resource.errors , :status => 422 }
      end
    end
  end


end
