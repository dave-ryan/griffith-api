class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :family_id
      t.integer :mystery_santa_id, optional: true
      t.string :password_digest
      t.string :santa_group
      t.boolean :is_admin, optional: true

      t.timestamps
    end
  end
end
