class Customgift < ApplicationRecord
  belongs_to :user
  belongs_to :customgift_purchaser, class_name: "User", foreign_key: "customgift_purchaser_id"

  validates :note, presence: true
  validates :user_id, presence: true
  validates :customgift_purchaser_id, presence: true
end
