class AddAcceptedToFriendships < ActiveRecord::Migration[5.0]
  def change
    add_column :friendships, :transition, :string
  end
end
