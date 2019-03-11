class AddFacebookDigestToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :facebook_digest, :string
  end
end
