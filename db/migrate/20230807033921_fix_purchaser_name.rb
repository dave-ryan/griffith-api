class FixPurchaserName < ActiveRecord::Migration[7.0]
  def change
    rename_column :customgifts, :purchaser_id, :customgift_purchaser_id
  end
end
