# TODO

# Javascript

Look at using webpack - good thoughts for Rails 4 from here: https://revs.runtime-revolution.com/want-to-use-es6-with-rails-right-now-webpack-to-the-rescue-ebefb2004e9e#.ouv5jkmo5

# DB

Try out rom-roda?

# Route

Possibility of using boolean matchers to handle authorization:

~~~{.ruby}
# ...
  r.on 'search' do
    r.on :id do |id|
      r.on user.not_allowed(url, id)
        "Error - 404"
      end
      r.on 'filter' do
        'OK: filter'
      end
      r.on 'run' do
        'OK: run'
      end
    end
  end
~~~

# Hidden and Invisible

