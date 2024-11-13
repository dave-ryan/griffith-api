class GiftSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :name, :purchaser_id, :link, :purchased_at

  belongs_to :user, serializer: UserMinSerializer
  belongs_to :purchaser, serializer: PurchaserSerializer
end
