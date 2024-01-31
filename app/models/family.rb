class Family < ApplicationRecord
  has_many :users
  has_many :secret_santas, through: :users
  has_many :gifts, through: :users
  has_many :purchasers, through: :gifts
  has_many :customgifts, through: :users
  has_many :customgift_purchasers, through: :customgifts

  validates :name, presence: true
end
