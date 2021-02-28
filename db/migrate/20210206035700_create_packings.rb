class CreatePackings < ActiveRecord::Migration[5.2]
  def change
    create_table :packings do |t|
      t.integer :user_id
      t.string :name,              null: false
      t.text :description
      t.integer :number_of_nights, null: false, default: 0
      t.string :packing_img
      t.boolean :is_public,       null: false, default: true

      t.timestamps null: false
    end
    add_index :packings, :user_id
  end
end
