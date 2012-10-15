class BlogsController < ApplicationController

  skip_before_filter :require_user

  def show
    @body_class = "blog"
    @posts = Post.published_posts
  end

end
