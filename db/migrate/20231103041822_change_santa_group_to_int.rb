class ChangeSantaGroupToInt < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :santa_group, 'integer USING CAST(santa_group AS integer)'
  end
end
