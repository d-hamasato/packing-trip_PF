class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :blog_id
      t.integer :parent_id
      t.string :comment, null:false

      t.timestamps null: false
    end
    add_index :comments, :user_id
    add_index :comments, :blog_id
    add_index :comments, :parent_id
  end
end
