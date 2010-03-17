class TestApp < Sinatra::Base
  configure do
    set(:environment, :test)
    set(:root, File.dirname(__FILE__))
  end

  register Sinatra::Bundles

  stylesheet_bundle(:test, %w(test1 test2))
  javascript_bundle(:test, %w(test1 test2 eval))
end