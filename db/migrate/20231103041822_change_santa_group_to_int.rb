class ChangeSantaGroupToInt < ActiveRecord::Migration[7.0]
  def up
    # Add a new column with the desired type
    add_column :users, :new_santa_group, :integer

    # Convert the existing data to the new type
    User.reset_column_information
    User.find_each do |user|
      user.update(new_santa_group: user.santa_group.to_i)
    end

    # Remove the old column
    remove_column :users, :santa_group

    # Rename the new column to match the original column name
    rename_column :users, :new_santa_group, :santa_group
  end

  def down
    # Revert the migration by doing the opposite operations
    add_column :users, :new_santa_group, :string

    User.reset_column_information
    User.find_each do |user|
      user.update(new_santa_group: user.santa_group.to_s)
    end

    remove_column :users, :santa_group

    rename_column :users, :new_santa_group, :santa_group
  end
end
