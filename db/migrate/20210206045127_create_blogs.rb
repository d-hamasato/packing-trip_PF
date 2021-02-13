class CreateBlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
      t.references :user, type: :integer,    foreign_key: true
      t.references :packing, type: :integer, foreign_key: true
      t.string :title,        null: false
      t.integer :category,    null: false, default: 0
      t.date :departed_date,  null: false
      t.string :blog_tmb_img
      t.text :content,        null: false
      t.string :destination

      t.timestamps null: false
    end
  end
end
