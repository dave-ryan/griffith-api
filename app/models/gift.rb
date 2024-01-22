class Gift < ApplicationRecord
  belongs_to :user
  belongs_to :purchaser, class_name: "User", foreign_key: "purchaser_id", optional: true
end
