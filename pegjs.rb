PEGJS_DIR = File.dirname(__FILE__) + "/public/vendor/pegjs"

require "sinatra/bundles"

configure do
  # Disable compression for now - it causes syntax errors in JavaScript.
  disable :compress_bundles

  stylesheet_bundle(:all, [
    "css/global.css"
  ])
  javascript_bundle(:online, [
    "vendor/jquery/jquery.js",
    "vendor/pegjs/lib/runtime.js",
    "vendor/pegjs/lib/compiler.js",
    "vendor/pegjs/lib/metagrammar.js",
    "vendor/base64/webtoolkit.base64.js",
    "vendor/jsdump/jsDump.js",
    "js/online.js",
  ])
end

helpers do
  def menu_item(id, title)
    "<a#{request.path_info == "/" + id ? " class=\"current\"" : ""} href=\"/#{id}\">#{title}</a>"
  end
end

before do
  @pegjs_version = File.read(PEGJS_DIR + "/VERSION").strip
end

get "/" do
  erb :index
end

get "/download" do
  @title = "Download"

  erb :download
end

get "/online" do
  @title = "Online Version"

  erb :online
end

get "/documentation" do
  @title = "Documentation"

  erb :documentation
end

get "/development" do
  @title = "Development"

  erb :development
end
