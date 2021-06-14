class AddRankToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :rank, :integer, default: 1
  end
end
