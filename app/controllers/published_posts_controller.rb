class PublishedPostsController < ApplicationController

  skip_before_filter :require_user


  def index
    @posts = Post.published_posts

    respond_to do |format|
      format.html {
        redirect_to blog_url, :status => 301
      }
      format.atom 
    end
  end

  def show
    @body_class = "blog"
    @post = Post.published_posts.find(params[:id])

    respond_to do |format|
      format.html # show.erb.html
    end
  end



end
