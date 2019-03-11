var io = require('socket.io').listen(8081),
    redis = require('redis').createClient();

redis.subscribe('rt-change');

io.on('connection', function(socket){
  console.log("ok");
  redis.on('message', function(channel, message){
    socket.emit('rt-change', JSON.parse(message));
  });
});




/*var http = require("http"),
    sio  = require("socket.io");
// create http server
var server = http.createServer().listen(8081, process.env.IP);
// create socket server
var io = sio.listen(server);
var redis = require('redis').createClient();
redis.subscribe('rt-change');
io.on('connection', function(socket){
  console.log("connect");
  redis.on('message', function(channel, message){
    socket.emit('rt-change', JSON.parse(message));
  });
});*/