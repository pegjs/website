PEGJS_DIR = File.dirname(__FILE__) + "/public/vendor/pegjs"

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
  @grammar = File.read(PEGJS_DIR + "/examples/arithmetics.pegjs").strip

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
