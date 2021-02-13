class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.references :followed, type: :integer, foreign_key: { to_table: :users }
      t.references :follower, type: :integer, foreign_key: { to_table: :users }

      t.timestamps null: false
    end
  end
end
