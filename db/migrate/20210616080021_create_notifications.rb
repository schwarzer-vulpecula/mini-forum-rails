class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :event, null: false
      t.integer :subject
      t.integer :verb
      t.integer :object
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
