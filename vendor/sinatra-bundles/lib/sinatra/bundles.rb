module Sinatra
  # Main Bundles Module
  module Bundles
    autoload :Helpers, 'sinatra/bundles/helpers'
    autoload :Bundle, 'sinatra/bundles/bundle'
    autoload :JavascriptBundle, 'sinatra/bundles/javascript_bundle'
    autoload :StylesheetBundle, 'sinatra/bundles/stylesheet_bundle'

    # Set a Javascript bundle
    #    javascript_bundle(:all, %w(jquery lightbox))
    # @param [Symbol,String] key The bundle name
    # @param [Array(String)] files The list of filenames, without extension,
    #   assumed to be in the public directory, under 'javascripts'
    def javascript_bundle(key, files)
      javascript_bundles[key] = JavascriptBundle.new(self, files)
    end

    # Set a CSS bundle
    #    stylesheet_bundle(:all, %w(reset grid fonts))
    # @param [Symbol,String] key The bundle name
    # @param [Array(String)] files The list of filenames, without extension,
    #   assumed to be in the public directory, under 'stylesheets'
    def stylesheet_bundle(key, files)
      stylesheet_bundles[key] = StylesheetBundle.new(self, files)
    end

    def self.registered(app)
      # Setup empty bundle containers
      app.set(:javascript_bundles, {})
      app.set(:stylesheet_bundles, {})

      # Setup defaults
      app.set(:bundle_cache_time, 60 * 60 * 24 * 365)
      app.disable(:compress_bundles)
      app.disable(:cache_bundles)
      app.enable(:stamp_bundles)

      # Production defaults
      app.configure :production do
        app.enable(:compress_bundles)
        app.enable(:cache_bundles)
      end

      app.helpers(Helpers)

      app.get('/stylesheets/bundles/:bundle.css') do |bundle|
        content_type('text/css')
        headers['Vary'] = 'Accept-Encoding'
        expires(options.bundle_cache_time, :public, :must_revalidate) if options.cache_bundles
        options.stylesheet_bundles[bundle.intern]
      end

      app.get('/javascripts/bundles/:bundle.js') do |bundle|
        content_type('text/javascript; charset=utf-8')
        headers['Vary'] = 'Accept-Encoding'
        expires(options.bundle_cache_time, :public, :must_revalidate) if options.cache_bundles
        options.javascript_bundles[bundle.intern]
      end
    end
  end

  register(Bundles)
end