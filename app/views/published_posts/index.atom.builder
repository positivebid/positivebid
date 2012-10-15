atom_feed do |feed|
  feed.title("PositiveBid")
  feed.updated((@posts.first.published_at))

  @posts.each do |post|
    feed.entry(post, :url => blog_post_url(post)) do |entry|
      entry.title(post.title)
      entry.content(RDiscount.new(post.body).to_html, :type => 'html')

      entry.author do |author|
        author.name(post.author)
      end
    end
  end
end
