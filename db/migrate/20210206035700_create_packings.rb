class CreatePackings < ActiveRecord::Migration[5.2]
  def change
    create_table :packings do |t|
      t.references :user, type: :integer, foreign_key: true
      t.string :name,              null: false
      t.text :description
      t.integer :number_of_nights, null: false, default: 0
      t.string :packing_img
      t.boolean :is_public?,       null: false, default: true

      t.timestamps null: false
    end
  end
end
