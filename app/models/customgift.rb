class Customgift < ApplicationRecord
  belongs_to :user
  belongs_to :customgift_purchaser, class_name: "User", foreign_key: "customgift_purchaser_id"
end
