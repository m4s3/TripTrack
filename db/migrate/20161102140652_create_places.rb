class CreatePlaces < ActiveRecord::Migration[5.0]
  def change
    create_table :places do |t|
      t.integer :user_id
      t.float :lat
      t.float :lng
      t.string :name
      t.integer :micropost_id

      t.timestamps
    end
    #add_index :places, [:user_id, :lat, :lng], unique: true
  end
end
