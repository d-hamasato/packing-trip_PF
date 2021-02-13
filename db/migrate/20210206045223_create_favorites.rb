class CreateFavorites < ActiveRecord::Migration[5.2]
  def change
    create_table :favorites do |t|
      t.references :user, type: :integer,    foreign_key: true
      t.references :item, type: :integer,    foreign_key: true
      t.references :packing, type: :integer, foreign_key: true
      t.references :blog, type: :integer,    foreign_key: true

      t.timestamps null: false
    end
  end
end
