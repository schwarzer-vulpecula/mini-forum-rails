class AddBannedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :banned, :boolean, default: false, null: false
  end
end
