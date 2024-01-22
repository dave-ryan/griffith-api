class CreateCustomgifts < ActiveRecord::Migration[7.0]
  def change
    create_table :customgifts do |t|
      t.integer :user_id
      t.integer :purchaser_id
      t.text :note

      t.timestamps
    end
  end
end
