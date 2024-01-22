class ChangeMyserySantaToSecret < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :mystery_santa_id, :secret_santa_id
  end
end
