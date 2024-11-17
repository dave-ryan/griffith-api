class User < ApplicationRecord
  has_secure_password
  validates :name, presence: true

  belongs_to :family
  belongs_to :secret_santa, class_name: "User", foreign_key: "secret_santa_id", optional: true

  has_many :gifts
  has_many :purchasers, through: :gifts, foreign_key: "purchaser_id"
  has_many :purchased_gifts, class_name: "Gift", foreign_key: "purchaser_id"

  has_many :customgifts
  has_many :customgift_purchasers, through: :customgifts, foreign_key: "customgift_purchaser_id"
  has_many :purchased_customgifts, class_name: "Customgift", foreign_key: "customgift_purchaser_id"

  has_many :friendships
  has_many :friends, through: :friendships, foreign_key: "user_Id"
end
