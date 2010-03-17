[
  "rainpress",
  "oyster",
  "packr",
  "sinatra-bundles",
  "sinatra"
].each { |gem| $LOAD_PATH.unshift(File.dirname(__FILE__) + "/vendor/#{gem}/lib") }

require "rubygems"
require "sinatra"

disable :run

require "pegjs"
run Sinatra::Application
