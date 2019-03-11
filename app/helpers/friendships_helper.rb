module FriendshipsHelper
  
  def friends? other_user
    #Ho aggiunto l'OR
    Friendship.where("(user_id = ? AND friend_id =  ?) OR (user_id = ? AND friend_id =  ?)",current_user.id , other_user.id,other_user.id,current_user.id).any?
  end
  
  def accepted? other_user
    Friendship.where("user_id = ? AND transition =  ? AND friend_id= ? ", current_user.id , "accepted", other_user.id).any?
  end
  
  def pending? other_user
      Friendship.where("user_id = ? AND transition =  ? AND friend_id = ? ", current_user.id, "pending", other_user.id).any?
  end
  
  
  def pending_friend? other_user
    Friendship.where("user_id = ? AND transition =  ? AND friend_id = ? ", other_user.id, "pending", current_user.id).any?
  end
end
