class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, :class_name => 'User'
  
  VALID_TRANSITION_REGEX = /\A(accepted)|(pending)/i
  validates :transition ,presence: true , format: { with: VALID_TRANSITION_REGEX }
  
  
end
