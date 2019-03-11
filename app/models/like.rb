class Like < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  
  #key
  
  #validates :user_id,:post_id, :uniqueness: {scope: :post_id}
end
