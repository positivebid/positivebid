class AuctionsController < ApplicationController

  resources_controller_for :auctions

  def new_resource(attributes = nil )
    super(attributes).tap do |r|
      Time.zone = r.time_zone if r.time_zone
    end
  end

  def find_resource(attributes = nil )
    super(attributes).tap do |r|
      Time.zone = r.time_zone if r.time_zone
    end
  end

  def update
    self.resource = find_resource

    resource_form_name = ActiveModel::Naming.singular(resource_class)
    attributes = params[resource_form_name] || params[resource_name] || {}


    respond_to do |format|
      if resource.update_attributes(attributes)
        format.html do
          flash[:notice] = "#{resource_name.humanize} was successfully updated."
          if params[:auction] and params[:auction][:state_event] == "organiser_submit_for_approval"
            flash[:success] = "Your Auction has been submitted to PositiveBid for approval. It is now in a <strong>submitted</strong> state. Once it has been approved it will become <strong>active</strong> as detailed in the <strong>Auction State</strong> below. "
          end
          redirect_to resource_url
        end
        format.js
        format.json { render json: resource, status: :ok }
      else
        format.html { render :action => "edit" }
        format.js   { render :action => "edit" }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

end
