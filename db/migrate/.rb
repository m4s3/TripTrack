class AddPictureToPlaces < ActiveRecord::Migration[5.0]
  def change
    add_column :places, :picture, :string
  end
end
