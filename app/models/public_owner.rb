class PublicOwner < ActiveRecord::Base
   include ActiveRecord::Singleton

   has_many :documents, :as => 'owner'
   has_many :published_documents, :as => 'owner', :conditions => {:published => true}, :class_name => 'Document'
   has_many :faqs, :as => 'owner'
   has_many :published_faqs, :as => 'owner', :conditions => {:published => true}, :class_name => 'Faq'

   def name
     "Public Owner"
   end

#   def add_an_avatar(filename)
#     basename = File.basename(filename)
#     unless avatars.find_by_image_filename(basename)
#      a = avatars.create!(:image_file => File.new(filename, 'rb'))
#      a.image_filename = basename
#      a.save
#     end
#   end
#
#   def self.default_avatar_ids
#     @_default_avatar_ids ||= self.instance.avatar_ids
#   end
#
#   def self.avatar_id_for(i)
#     default_avatar_ids[ i % default_avatar_ids.size ]
#   end
#
#
#   def pic_id
#     avatar_ids.last
#   end
#
#  def pic
#    Avatar.find(pic_id)
#  end

end
