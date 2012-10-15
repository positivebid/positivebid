class FaqsController < ApplicationController

  resources_controller_for :faqs
  cache_sweeper :faq_sweeper

end
