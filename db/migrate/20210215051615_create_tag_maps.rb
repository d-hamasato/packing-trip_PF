class CreateTagMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_maps do |t|
      t.integer :tag_id
      t.integer :item_id
      t.integer :packing_id
      t.integer :blog_id

      t.timestamps
    end
    add_index :tag_maps, :tag_id
    add_index :tag_maps, :item_id
    add_index :tag_maps, :packing_id
    add_index :tag_maps, :blog_id
  end
end
