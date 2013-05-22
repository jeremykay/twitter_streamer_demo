require 'eventmachine'
require 'em-websocket'

EM.run do
  puts "Server started on 127.0.0.1:4000 (open index.html in your browser)"
  EM::WebSocket.start(:host => '127.0.0.1', :port => 4000) do |websocket|
    websocket.onopen { puts "Client connected" }
    websocket.onmessage do |msg|
      p msg
      websocket.send(msg)
    end
  end
end