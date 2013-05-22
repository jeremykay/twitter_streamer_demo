$: << File.expand_path(File.dirname(__FILE__))
require 'rubygems'
require 'bundler/setup'
require 'eventmachine'
require 'em-websocket'
require 'twitter_stream'
require 'auth_keys'

TWITTER_TERM = 'one direction'

EM.run {
  puts "Server started on 127.0.0.1:4000"
  websocket_connections = []
  
  EM::WebSocket.start(:host => '127.0.0.1', :port => 4000) do |ws|
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
    puts "#{tweet}"
    websocket_connections.each do |socket|
      socket.send(JSON.generate({
        :tweet => tweet
      }))
    end
  }
}
