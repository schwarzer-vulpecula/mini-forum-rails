class AddMuteToPostsAndComments < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :mute, :boolean, default: false, null: false
    add_column :comments, :mute, :boolean, default: false, null: false
  end
end
