require 'sinatra/bundles/bundle'
require 'rainpress'

module Sinatra
  module Bundles
    # Bundle for stylesheets
    class StylesheetBundle < Bundle
      # Generate the HTML tag for the stylesheet
      #
      # @param [String] name The name of a bundle
      # @return [String] The HTML that can be inserted into the doc
      def to_html(name)
        "<link type='text/css' href='/stylesheets/bundles/#{name}.css#{@app.stamp_bundles ? "?#{stamp}" : ''}' rel='stylesheet' media='screen' />"
      end

    protected

      # Compress CSS
      #
      # @param [String] css The CSS to compress
      # @return [String] Compressed CSS
      def compress(css)
        Rainpress.compress(css)
      end

      # Get the path of the file on disk
      #
      # @param [String] filename The name of sheet,
      #   assumed to be in the public directory
      # @return [String] The full path to the file
      def path(filename)
        File.join(@app.public, filename)
      end
    end
  end
end
