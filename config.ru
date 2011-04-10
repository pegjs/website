$LOAD_PATH.unshift(
  File.dirname(__FILE__) + "/vendor/tilt/lib",
  File.dirname(__FILE__) + "/vendor/sinatra/lib"
)

require "rubygems"
require "sinatra"

disable :run

require "pegjs"
run Sinatra::Application
