class QuestionSweeper < ActionController::Caching::Sweeper
  observe Question

  def sweep(question)
    if question.faq
      expire_page public_published_faq_path(question.faq)
    end
  end

  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep

end
