class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.integer :user_id

      t.timestamps null: false
    end
    add_index :rooms, :user_id
  end
end
