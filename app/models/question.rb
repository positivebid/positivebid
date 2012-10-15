class Question < ActiveRecord::Base
  attr_accessible :position, :published, :body, :title

  belongs_to :faq, :inverse_of => :questions, :touch => true
  acts_as_list :scope => :faq

  validates_presence_of :title 

  def to_param
    @to_param ||= "#{id}-#{title.parameterize}" 
  end

  def self.order_by_ids(ids)
    logger.debug('ids is ' + ids.inspect);
    transaction do
      ids.each_index do |i|
        find(ids[i]).update_column(:position, i+1)
      end
    end
  end

end
