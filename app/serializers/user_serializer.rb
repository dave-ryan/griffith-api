class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :family, :is_admin, :santa_group, :secret_santa_id, :birthday

  belongs_to :family
  has_many :gifts
  has_many :customgifts
end
