require './roda_frame.rb'
use Rack::Session::Cookie, secret: "some_nice_long_random_string_DSKJH4378EYR7EGKUFH", key: "_myapp_session"

run RodaFrame
