class FaqSweeper < ActionController::Caching::Sweeper
  observe Faq

  def sweep(faq)
    expire_page public_published_faq_path(faq)
  end

  alias_method :after_create, :sweep
  alias_method :after_update, :sweep
  alias_method :after_destroy, :sweep

end
