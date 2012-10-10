class PicturesController < ApplicationController

  resources_controller_for :pictures

  caches_page :p20, :gzip => :best_speed
  caches_page :p40, :gzip => :best_speed
  caches_page :p80, :gzip => :best_speed
  caches_page :p100, :gzip => :best_speed
  caches_page :p160, :gzip => :best_speed
  caches_page :p200, :gzip => :best_speed
  caches_page :p320, :gzip => :best_speed
  caches_page :p400, :gzip => :best_speed
  caches_page :p640, :gzip => :best_speed
  caches_page :xs, :gzip => :best_speed
  caches_page :s, :gzip => :best_speed
  caches_page :m, :gzip => :best_speed
  caches_page :l, :gzip => :best_speed
  caches_page :xl, :gzip => :best_speed
  caches_page :xxl, :gzip => :best_speed
  caches_page :o, :gzip => :best_speed

  def o
    self.resource = resource_class.find(find_resource.id) # force full reload
  end

  alias :p20 :o
  alias :p40 :o
  alias :p80 :o
  alias :p100 :o
  alias :p160 :o
  alias :p200 :o
  alias :p320 :o
  alias :p400 :o
  alias :p640 :o
  alias :xs :o
  alias :s :o
  alias :m :o
  alias :l :o
  alias :xl :o
  alias :xxl :o

end
