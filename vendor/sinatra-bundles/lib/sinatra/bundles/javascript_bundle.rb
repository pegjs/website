require 'sinatra/bundles/bundle'
require 'packr'

module Sinatra
  module Bundles
    # Bundle for javascripts
    class JavascriptBundle < Bundle
      # Generate the HTML tag for the script file
      #
      # @param [String] name The name of a bundle
      # @return [String] The HTML that can be inserted into the doc
      def to_html(name)
        "<script type='text/javascript' src='/javascripts/bundles/#{name}.js#{@app.stamp_bundles ? "?#{stamp}" : ''}'></script>"
      end

    protected

      # Compress Javascript
      #
      # @param [String] js The Javascript to compress
      # @return [String] Compressed Javascript
      def compress(js)
        # Don't shrink variables if the file includes a call to `eval`
        Packr.pack(js, :shrink_vars => !js.include?('eval('))
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
