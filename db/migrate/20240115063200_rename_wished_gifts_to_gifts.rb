class RenameWishedGiftsToGifts < ActiveRecord::Migration[7.0]
  def change
    rename_table :wishedgifts, :gifts
  end
end
