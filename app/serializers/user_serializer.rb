class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :family, :is_admin, :santa_group, :secret_santa_id, :birthday

  belongs_to :family
  belongs_to :secret_santa, class_name: "User", foreign_key: "secret_santa_id", serializer: UserMinSerializer

  has_many :gifts
  has_many :purchasers, through: :gifts, foreign_key: "purchaser_id"
  has_many :purchased_gifts, class_name: "Gift", foreign_key: "purchaser_id"
  has_many :customgifts
  has_many :customgift_purchasers, through: :customgifts, foreign_key: "customgift_purchaser_id"
  has_many :purchased_customgifts, class_name: "Customgift", foreign_key: "customgift_purchaser_id"
end
