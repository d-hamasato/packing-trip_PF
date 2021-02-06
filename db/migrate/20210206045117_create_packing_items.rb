class CreatePackingItems < ActiveRecord::Migration[5.2]
  def change
    create_table :packing_items do |t|
      t.references :item,    foreign_key: true
      t.references :packing, foreign_key: true
      t.integer :qty, null: false, default: 1

      t.timestamps null: false
    end
  end
end
