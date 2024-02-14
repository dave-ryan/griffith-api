class CustomgiftSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :customgift_purchaser_id, :note, :purchased_at
  belongs_to :user
  has_one :customgift_purchaser, serializer: CustomgiftPurchaserSerializer
end
