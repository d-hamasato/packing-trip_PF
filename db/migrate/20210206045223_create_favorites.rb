class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :packing_id
      t.integer :blog_id

      t.timestamps null: false
    end
    add_index :favorites, :user_id
    add_index :favorites, :item_id
    add_index :favorites, :packing_id
    add_index :favorites, :blog_id
  end
end
