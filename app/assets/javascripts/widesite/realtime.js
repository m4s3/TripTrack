function notifyMe(message) {
  if (!("Notification" in window))
    alert("This browser does not support desktop notification");

  else if (Notification.permission === "granted") {
    // If it's okay let's create a notification
    var url="https://triptrack-ggd94.c9users.io/users/"+message.friend_id;
    var notification = new window.Notification("Hello!",
      {
        body: message.resource
      });
      setTimeout(function(){ location.assign(url) }, 5000);

    
  }

  else if (Notification.permission !== 'denied') {
    Notification.requestPermission(function (permission) {
      // If the user accepts, let's create a notification
      if (permission === "granted") {
        var url="https://triptrack-ggd94.c9users.io/users/"+message.friend_id;
        var notification = new window.Notification("Hello!",
      {
        body: message.resource
      });
      
      setTimeout(function(){ location.assign(url) }, 5000);

    
      }
    });
  }
}



function listen(id){
  socket = io.connect("https://triptrack-ggd94.c9users.io:8081",{secure:true});
  socket.on("rt-change", function(message){
    if( id == message.friend_id)
      notifyMe(message);
  });
}

