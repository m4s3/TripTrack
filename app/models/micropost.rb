class Micropost < ApplicationRecord
  mount_uploader :picture, PictureUploader
  
  belongs_to :user
  has_one :place
  
  has_many :likes
  has_many :liker, :through => :likes ,:source => :user
  
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size
  
  
  private

    # Validates the size of an uploaded picture.
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
