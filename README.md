Getting started
---------------

First add your twitter username and password. Then server.rb and once it's started open websocket.html in your browser. You should see some tweets appear. If not take a look at the javascript console.

Based off of this very helpful tutorial:
<http://rubylearning.com/blog/2010/10/01/an-introduction-to-eventmachine-and-how-to-avoid-callback-spaghetti/>

Must include a file called `auth_keys.rb` that has the following:

```
TWITTER_USERNAME = 'username'
TWITTER_PASSWORD = 'password'
```

Then:

```
bundle install
bundle exec ruby server.rb
```

Browse to: `websocket.html` in a local browser and enjoy!