class QuestionsController < ApplicationController

  resources_controller_for :questions
  cache_sweeper :question_sweeper

  def preview
    @question = resource_service.new(params[:admin_question])
  end

  def order
    order = params[resource_class.name.downcase]
    resource_service.order_by_ids(order)
  end

end
