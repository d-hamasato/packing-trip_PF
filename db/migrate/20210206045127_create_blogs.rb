class CreateBlogs < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
      t.references :user,    foreign_key: true
      t.references :packing, foreign_key: true
      t.string :title,        null: false
      t.integer :category,    null: false, default: 0
      t.date :departed_date,  null: false
      t.string :blog_tmb_img, null: false, default: "/no_images/no_image_blog_tmb_img.jpg"
      t.text :content,        null: false
      t.string :destination

      t.timestamps null: false
    end
  end
end
