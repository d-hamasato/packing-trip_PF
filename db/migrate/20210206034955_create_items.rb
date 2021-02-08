class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :user, foreign_key: true
      t.string :name,        null: false
      t.text :description
      t.string :item_img
      t.integer :weight
      t.boolean :is_public?, null: false, default: true
      t.boolean :has?,       null: false, default: true

      t.timestamps null: false
    end
  end
end
