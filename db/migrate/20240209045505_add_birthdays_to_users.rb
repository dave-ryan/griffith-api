class AddBirthdaysToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :birthday, :timestamp
  end
end
