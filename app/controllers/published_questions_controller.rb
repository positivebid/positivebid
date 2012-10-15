class PublishedQuestionsController < ApplicationController

  resources_controller_for :published_questions, :source => :published_questions, :class => Question

end
