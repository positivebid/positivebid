class Faq < ActiveRecord::Base
  attr_accessible :after_html, :before_html, :key, :published, :show_answers_on_faq, :show_index, :show_position, :title

  validates_presence_of :title, :key
  validates_uniqueness_of :key

  belongs_to :owner, :polymorphic => true
  has_many :questions, :inverse_of => :faq, :dependent => :destroy, :order => 'position'

  has_many :published_questions, :class_name => 'Question', :conditions => { :published => true }, :order => "position"

  def to_param
    @to_param ||= "#{id}-#{title.parameterize}"  
  end


end
