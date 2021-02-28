class CreatePackingItems < ActiveRecord::Migration[5.2]
  def change
    create_table :packing_items do |t|
      t.integer :item_id
      t.integer :packing_id
      t.integer :qty, null: false, default: 1

      t.timestamps null: false
    end
    add_index :packing_items, :item_id
    add_index :packing_items, :packing_id
  end
end
