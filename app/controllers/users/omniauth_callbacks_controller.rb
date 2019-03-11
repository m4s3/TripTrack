class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  include HTTParty
  
  
  
  
  def facebook
    #controlla le autorizzazione negate e gestisci
    #usa l'access token come sessione e metti il digest nel db
    
    auth=request.env["omniauth.auth"]
    @user = User.from_omniauth(auth)

    if @user.persisted?  #persisted return true if the user exists and hasn't been destroy
      digest = User.digest(auth.credentials.token)
      @user.facebook_token=auth.credentials.token
      
      if @user.provider and @user.uid #allora ci sarà anche la mail
        @user.update_columns facebook_digest: digest
        
      else #ha solo la mail
        @user.update_columns(provider: auth.provider , uid: auth.uid ,
                              activated: true , facebook_digest: digest )
      end
      log_in @user
      face_api
      redirect_to @user
    else
      if @user.valid?
       log_in @user
       face_api
       redirect_to @user
      else
        render 'users/new'
      end
    end
  end

  def failure
    redirect_to root_path
  end
  
  private
  
    def face_api
      face_uri="https://graph.facebook.com/v2.8"
      
      options_place = { query: {fields: "place", access_token: @user.facebook_token} }
      options_friends_tag_places= { query: {fields: "tagged_places,friends", access_token: @user.facebook_token} }
      options_feed= { query: {fields: "place,attachments", access_token: @user.facebook_token} }
        
      param_face= {place: { option: options_place , url:  face_uri+'/me/photos' } ,
                   friends_tag_places: { option: options_friends_tag_places , url: face_uri+'/me' },
                   feed: { option: options_feed ,url: face_uri+'/me/feed' } }
              
      getFaceGraph param_face
    end
    
    
    def load_or_create( name_class, hash )
       obj=name_class.find_by(hash)
       
       if obj.nil?
         
         obj=name_class.new(hash)
         
         if obj.valid?
           
           obj.save
           obj
           
         else
           nil
         end
         
       else
         obj
       end
       
    end
  
    def getFaceGraph(param_face)
      param_face.each do |key,value|
        response=self.class.get value[:url] , value[:option]
        puts key
        #prova e vedi
        if response.success?

          if key == :place
            #puts  response["data"].to_s
            array= response["data"]
            array.each do |i|
              i.each do |key1,value1|
                if key1 == "place"
                  location=i[key1]["location"]
                  name=location["city"]
                  lat=location["latitude"]
                  lng=location["longitude"]
                  hash={:user_id => @user.id,:lat =>lat , :lng => lng, :name=> name}
                  load_or_create(Place,hash)
                end
              end
            end
          end
          

          
          if key ==:friends_tag_places
            array= response["tagged_places"]["data"]
            array.each do |i|
              i.each do |key1,value1|
                if key1 == "place"
                  location=i[key1]["location"]
                  name=location["city"]
                  lat=location["latitude"]
                  lng=location["longitude"]
                  hash={:user_id => @user.id,:lat =>lat , :lng => lng, :name=> name}
                  load_or_create(Place,hash)
                end
              end
            end
          end
          
          if key ==:feed
            #puts response["data"].to_s,"",""
            array= response["data"]
            
            array.each do |i|
              i.each do |key1,value1|
                if key1 == "place"
                  
                  location=i[key1]["location"]
                  name=location["city"]
                  lat=location["latitude"]
                  lng=location["longitude"]
                  hash={:user_id => @user.id,:lat =>lat , :lng => lng, :name=> name}
                  p=load_or_create(Place,hash)
                  puts "prova1"
                  
                  if i.key?("attachments") and !p.nil?
                    puts "prova2"
                    array2=i["attachments"]["data"] 
                    array2.each do |m|
                      m.each do |key2,value2|
                        if key2 == "media"
                          src= m[key2]["image"]["src"]
                          puts src,"oooooo",p.id
                          hash={:picture => src, :place_id =>p.id}
                          load_or_create(Photo,hash)
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        else
          raise response.response
        end
      end
    end
end