class CreateBlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
      t.integer :user_id
      t.integer :packing_id
      t.string :title,        null: false
      t.integer :category,    null: false, default: 0
      t.date :departed_date,  null: false
      t.string :blog_tmb_img
      t.text :content,        null: false
      t.string :destination
      t.boolean :is_public, null: false, default: true

      t.timestamps null: false
    end
    add_index :blogs, :user_id
    add_index :blogs, :packing_id
  end
end
