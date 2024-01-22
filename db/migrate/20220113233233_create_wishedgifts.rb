class CreateWishedgifts < ActiveRecord::Migration[7.0]
  def change
    create_table :wishedgifts do |t|
      t.integer :user_id
      t.integer :purchaser_id, optional: true
      t.string :name
      t.string :link

      t.timestamps
    end
  end
end
