class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :user,   foreign_key: true
      t.references :blog,   foreign_key: true
      t.references :parent, foreign_key: { to_table: :comments }
      t.string :comment, null:false

      t.timestamps null: false
    end
  end
end
