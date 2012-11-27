class UserSerializer < ActiveModel::Serializer
  embed :ids
  attributes :id, :first_name, :last_name, :provider, :time_zone, :image_url


end
