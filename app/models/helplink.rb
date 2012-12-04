class Helplink < ActiveRecord::Base
  attr_accessible :content, :key, :title

  validates_presence_of :key, :title, :content
  validates_uniqueness_of :key

  belongs_to :user

end
