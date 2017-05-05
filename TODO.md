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

# CSRF tags

Must have csrf for rodauth to work, but then all other forms need to include csrf tag.
Roda plugin has csrf_tag method, but then it needs to be passed to our view code so it can be passed to the Crossbeams::Layout for rendering.
Implemented in show_page helper.

# Searching

* Move helpers into the data_grid plugin.
* Use plugin for dm portal too?
* JS...

