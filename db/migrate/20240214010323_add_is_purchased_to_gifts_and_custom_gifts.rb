class AddIsPurchasedToGiftsAndCustomGifts < ActiveRecord::Migration[7.0]
  def change
    add_column :gifts, :purchased_at, :timestamp
    add_column :customgifts, :purchased_at, :timestamp
  end
end
