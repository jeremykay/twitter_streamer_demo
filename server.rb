$: << File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require 'bundler/setup'
require 'eventmachine'
require 'em-websocket'
require 'twitter_stream'
require 'auth_keys'

TWITTER_TERM = 'doors'

EM.run {
  websocket_connections = []
  
  EM::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
    ws.onopen {
      puts "Websocket connection opened"
      websocket_connections << ws
    }
    ws.onclose {
      puts "Websocket connection closed"
      websocket_connections.delete(ws)
    }
    ws.onerror { |error|
      puts error
    }
    ws.onmessage { |msg|
      puts "Recieved message: #{msg}"
      # ws.send "Pong: #{msg}"
    }
  end
  
  stream = TwitterStream.new(TWITTER_USERNAME, TWITTER_PASSWORD, TWITTER_TERM)
  stream.ontweet { |tweet|
    puts tweet
    p websocket_connections.inspect
    websocket_connections.each do |socket|
      puts "socket: "
      socket.send(JSON.generate({
        :tweet => tweet
      }))
    end
  }
}
