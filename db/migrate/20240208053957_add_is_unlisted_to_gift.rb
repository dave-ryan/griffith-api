class AddIsUnlistedToGift < ActiveRecord::Migration[7.0]
  def change
    add_column :gifts, :is_unlisted, :boolean
  end
end
