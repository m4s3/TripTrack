class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :picture
      t.integer :place_id

      t.timestamps
    end
    #add_index :photos, [:picture], unique: true    # sbagliato
  end
end
