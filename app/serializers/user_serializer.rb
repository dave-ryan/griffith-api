class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :family, :is_admin, :santa_group, :secret_santa_id, :birthday, :share_code

  belongs_to :family
  belongs_to :secret_santa, class_name: "User", foreign_key: "secret_santa_id"

  has_many :gifts
  has_many :customgifts
  has_many :friends, through: :friendships, foreign_key: "user_Id"
end
