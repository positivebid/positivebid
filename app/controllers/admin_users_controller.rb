class AdminUsersController < ApplicationController
  before_filter :require_admin
  resources_controller_for :admin_users, :class => User

  def find_resources
    results = resource_service.page( params[:page] ).order(params[:order] || 'last_request_at DESC')
    if params[:search] && params[:search][:first_name].present?
      results = results.where(["first_name ilike ?", "%#{params[:search][:first_name]}%"])
    elsif params[:search] && params[:search][:email].present?
      results = results.where(["email ilike ?", "%#{params[:search][:email]}%"])
    end
    results
  end


  def report
  end

end
