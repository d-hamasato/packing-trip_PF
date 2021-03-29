class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :sender_id,    null: false
      t.integer :recipient_id, null: false
      t.integer :blog_id
      t.integer :comment_id
      t.integer :message_id
      t.integer :action,       null: false
      t.boolean :checked,      null: false, default: false

      t.timestamps
    end
    add_index :notifications, :sender_id
    add_index :notifications, :recipient_id
    add_index :notifications, :blog_id
    add_index :notifications, :comment_id
    add_index :notifications, :message_id
  end
end
