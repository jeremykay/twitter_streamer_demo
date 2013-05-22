require 'em-http-request'
require 'json'

class TwitterStream
  URL = 'https://stream.twitter.com/1.1/statuses/filter.json'
  
  def initialize(username, password, term)
    @username, @password = username, password
    @term = term
    @callbacks = []
    @buffer = ""
    listen
  end
  
  def ontweet(&block)
    @callbacks << block
  end
  
  private
  
  def listen
    http = EventMachine::HttpRequest.new(URL).post({
      :head => { 'Authorization' => [@username, @password] },
      :query => { "track" => @term }
    })
    
    http.stream do |chunk|
      @buffer += chunk
      process_buffer
    end
  end
  
  def process_buffer
    while line = @buffer.slice!(/.+\r\n/)
      tweet = JSON.parse(line)

      @callbacks.each { |c| c.call(tweet['text']) }
    end
  end
end
