class CustomgiftSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :customgift_purchaser_id, :note, :purchased_at

  belongs_to :user
  belongs_to :customgift_purchaser, serializer: PurchaserSerializer
end
