class AdminUsersController < ApplicationController
  before_filter :require_admin
  resources_controller_for :admin_users, :class => User

  def find_resources
    results = resource_service.page( params[:page] ).order(params[:order] || 'last_request_at DESC')
    if params[:search] && params[:search][:login].present?
      results = results.where(["login ilike ?", "%#{params[:search][:login]}%"])
    elsif params[:search] && params[:search][:email].present?
      results = results.where(["email ilike ?", "%#{params[:search][:email]}%"])
    end
    results
  end


  def report
  end

end
