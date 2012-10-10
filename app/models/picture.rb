class Picture < ActiveRecord::Base
  attr_accessible :image_file_data, :image_filename, :image_format, :image_height, :image_width, :image_file, :image_file_url, :data64


  belongs_to :owner, :polymorphic => true

  LITE_SELECT = 'owner_id, owner_type, id, creator_id, image_filename, image_height, image_format, created_at, updated_at'


  def self.random_color(seed = 0)
    old_seed = srand seed
    color = "#"
    3.times do 
      color << rand(256).to_s(16).sub(/^(\w)$/, "0\\1")
    end
    srand old_seed
    return color
  end

  acts_as_fleximage do
    image_storage_format :jpg
    output_image_jpg_quality 95
    require_image false
    default_image :size => '200x200', :color => 'green'
    #default_image_path File.join('public', 'images', 'icons', 'anonymous-dude.jpg')


    preprocess_image do |image|
      image.resize '1024x1024'
    end
  end


  def data64=(data)
    self.image_filename = "base64.jpg"
    self.image_file_data = Base64.decode64(data)
  end

  # overrinding a fleximage method here...
  def master_image_not_found
    our_id = id
    @output_image = Magick::Image.new(100, 100) do
      self.background_color = Picture.random_color(our_id)
    end
    GC.start
    @output_image
  end

  def rmagic_image_public
    load_image # from fleximage
    @output_image
  end

  def rmagic_square
    load_image # from fleximage
    side = @output_image.columns < @output_image.rows ? @output_image.columns : @output_image.rows
    @output_image.crop(Magick::CenterGravity, side, side)
  end

  # special code here for generating new_ids (to help with image caching)
  before_save :new_id
  after_save :reload_owner

  def new_id
    if !new_record?
      @old_id = id
      next_id = nil  # for variable scoping.
      transaction do
        next_id = connection.select_rows("select nextval('pictures_id_seq')").first.first
        connection.update_sql("update pictures set id = '#{next_id}' where id = #{@old_id}")
      end
      write_attribute :id,  next_id
    end
  end

  def reload_owner
    if @old_id
      owner.reload
    end
  end


end
