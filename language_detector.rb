require 'em-http'
require 'json'

class LanguageDetector
  URL = "http://www.google.com/uds/GlangDetect"
  
  include EM::Deferrable
  
  def initialize(text)
    request = EM::HttpRequest.new(URL).get({
      :query => {:v => "1.0", :q => text}
    })
    
    # This is called if the request completes successfully (whatever the code)
    request.callback {
      begin
        if request.response_header.status == 200
          info = JSON.parse(request.response)["responseData"]
          if info['isReliable']
            self.succeed(info['language'])
          else
            self.fail("Language could not be reliably determined")
          end
        else
          self.fail("Call to fetch language failed")
        end
      rescue
        puts request.response
        self.fail
      end
    }
    
    # This is called if the request totally failed
    request.errback {
      self.fail("Error making API call")
    }
  end
end
