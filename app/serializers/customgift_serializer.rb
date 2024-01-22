class CustomgiftSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :customgift_purchaser_id, :note
  belongs_to :user
  has_one :customgift_purchaser, serializer: CustomgiftPurchaserSerializer
end
