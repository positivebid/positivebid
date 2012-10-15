class Post < ActiveRecord::Base
  attr_accessible :author, :body, :published, :published_at, :title

  scope :published_posts, :conditions => { :published => true }, :order => "published_at DESC"

  validates_presence_of :title
  validates_presence_of :body
  validates_presence_of :author
  validates_presence_of :published_at

  after_initialize :gen_defaults

  def gen_defaults
    unless published_at
      self.published_at = Time.now 
    end
    unless author
      self.author = "Jason"
    end
  end

  def body_html
    RedCloth.new(body).to_html
  end

  def to_param 
    "#{id}-#{title.try(:parameterize)}" 
  end 

  def display_at 
    published_at || created_at || Time.now 
  end

end
