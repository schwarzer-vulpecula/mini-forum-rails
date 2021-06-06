class UniqueUsernames < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.index :username, unique: true
    end
  end
end
