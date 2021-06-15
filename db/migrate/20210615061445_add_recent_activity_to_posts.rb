class AddRecentActivityToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :recent_activity, :datetime, :default => DateTime.now
  end
end
