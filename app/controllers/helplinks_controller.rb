class HelplinksController < ApplicationController

  resources_controller_for :helplinks


  before_filter :require_admin, :only => [:new, :create, :update, :edit, :destroy ]
  #cache_sweeper :helplinks

  def find_resource
    if params[:id] =~ /^\D/
      resource_service.find_by_key params[:id]
    else
      resource_service.find params[:id]
    end
  end


  def new_resource
    super.tap{|d| d.user = current_user }
  end

  def update
    self.resource = find_resource
    resource.user = current_user

    resource_form_name = ActiveModel::Naming.singular(resource_class)
    attributes = params[resource_form_name] || params[resource_name]

    respond_to do |format|
      if resource.update_attributes(attributes)
        format.html do
          flash[:notice] = "#{resource_name.humanize} was successfully updated."
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
