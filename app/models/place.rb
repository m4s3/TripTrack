class Place < ApplicationRecord
  
  belongs_to :user
  has_one :micropost
  has_many :photos
  validates :user_id, presence: true
  validates :lat, presence: true
  validates :lng, presence: true
  
  #validates :user_id, uniqueness: { scope: [:lat,:lng]}
  
end

