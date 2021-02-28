class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.integer :user_id
      t.string :name,        null: false
      t.text :description
      t.string :item_img
      t.integer :weight
      t.boolean :is_public, null: false, default: true
      t.boolean :has,       null: false, default: true

      t.timestamps null: false
    end
    add_index :items, :user_id
  end
end
