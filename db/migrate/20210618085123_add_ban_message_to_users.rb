class AddBanMessageToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :ban_message, :string
  end
end
