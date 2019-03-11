class Photo < ApplicationRecord
  #mount_uploader :picture, PictureUploader
  belongs_to :place
  validates :place_id, presence: true
  validates :picture, presence: true
  
end