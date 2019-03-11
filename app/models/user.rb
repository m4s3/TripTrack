class User < ApplicationRecord
  
  has_many :places, dependent: :destroy
  has_many :notifies
  has_many :likes, dependent: :destroy
  has_many :liked_posts, :through => :likes, :source => :micropost
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token, :facebook_token
  
  before_save   :downcase_email
  before_create :create_activation_digest
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  has_secure_password
  
  devise :omniauthable, :omniauth_providers => [:facebook]
  
  
  
##############################################################################################################################################

  def request_friends
    friend_ids = "SELECT user_id  FROM friendships WHERE transition = 'pending' AND user_id != ? AND
    friend_id = ? "
    User.where("id IN (#{friend_ids})",id,id)
  end
  
  def check_super
    num_friends= Friendship.where("transition = ? AND (user_id = ? OR friend_id = ?)", 'accepted',
                     id,id).count
    if num_friends>0
      update_columns(super_user: true)
    else
      update_columns(super_user: false)
    end
    
  end
 # select *
  #from User
  #where id in (select friend_id from friendhsip where tran=pend and from_user_id <> 1)
  
  
  def add_like(post_id)
    likes.create(micropost_id: post_id)
  end
  
  
  def require_friend(other_user)
    friendships.create(friend_id: other_user.id, transition: :pending)
  end

  
  def delete_friend(other_user)
    friendships.find_by(friend_id: other_user.id).destroy
  end
  
  def accepted_friend(user)
    f=friendships.find_by(friend_id: user.id)
    f.update_columns transition:  :accepted
  end
  
  def friend?(other_user)
    friendships.find_by(friend_id:other_user.id)
  end
  
  
  def pending_request?(other_user)
    friendships.find_by(friend_id: other_user.id, transition: :pending)
  end 
  
  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id) if (other_user.super_user? && !(friend?(other_user) || other_user.friend?(self)))
  end
  
  def User.from_omniauth(auth) 
    digest=User.digest(auth.facebook_token)
    user=find_by(provider: auth.provider, uid: auth.uid)
    if user.nil?
      user=find_by(email: auth.info.email)
      if user.nil?
        user=User.new(email: auth.info.email, password: Devise.friendly_token[0,20],
                      name: auth.info.name, facebook_token: auth.credentials.token,
                      facebook_digest: digest , activated: true)
        user.save
        user
      else
        user
      end
    else
      user
    end
  end
  
  

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
  
  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end
  
  def friend
    friend_ids1 = "SELECT friend_id  FROM friendships WHERE transition != 'pending' AND user_id= ? "
    friend_ids2=  "SELECT user_id From friendships WHERE transition != 'pending' AND friend_id = ? "
    User.where("id IN (#{friend_ids1}) OR id IN(#{friend_ids2}) ",id, id )
  end
  
  def create_reset_digest
    self.reset_token = User.new_token
    #update_attribute(:reset_digest,  User.digest(reset_token))
    #update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
  end
  
  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end
  
  
  # Activates an account.
  def activate
    #update_attribute(:activated,    true)
    #update_attribute(:activated_at, Time.zone.now)
    #1 solo accesso al db
    update_columns(activated: true, activated_at: Time.zone.now)

  end
  
  

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  #def authenticated?(remember_token)
    #return false if remember_digest.nil?
    #BCrypt::Password.new(remember_digest).is_password?(remember_token)
  #end
  
  #Generalizzato sia per remember che per activation
  
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  
  private
  
    def downcase_email
      email.downcase!
    end
  
    # Creates and assigns the activation token and digest.
    
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end